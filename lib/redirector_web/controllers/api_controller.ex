defmodule RedirectorWeb.ApiController do
  use RedirectorWeb, :controller

  def debug(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, inspect(conn))
  end


  def is_preferred_visitor(conn, _params) do
    remote_ip =
      case x_forwarded_for(conn) do
        {:ok, addr} -> addr
        {:error, _} -> as_string(ip: conn.remote_ip)
      end

    remote_domain =
      case Host.reverse_lookup(ip: remote_ip) do
        {:ok, domain} -> domain
        {:error, _} -> "No Domain"
      end

    answer =
      case Redirector.preferred_visitor?(domain: remote_domain) do
        true ->
          "yes"

        false ->
          "no"
      end

    content = %{
      "remote_ip" => remote_ip,
      "remote_domain" => remote_domain,
      "is_preferred_visitor" => answer,
    }

    conn
    |> put_resp_content_type("text/json")
    |> send_resp(200, Poison.encode!(content))
  end


  defp x_forwarded_for(conn) do
    case Enum.find(conn.req_headers, fn {k, _v} -> k == "x-forwarded-for" end) do
      {"x-forwarded-for", ip_string} -> {:ok, ip_string}
      nil -> {:error, "Not found"}
    end
  end

  defp as_string(ip: {a,b,c,d}) do
    "#{a}.#{b}.#{c}.#{d}"
  end
end
