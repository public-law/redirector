defmodule RedirectorWeb.ApiController do
  use RedirectorWeb, :controller

  def debug(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, inspect(conn))
  end

  def is_preferred_visitor(conn, _params) do
    ip =
      case x_forwarded_for(conn) do
        {:ok, addr} -> addr
        {:error, _} ->
          {a, b, c, d} = conn.remote_ip
          "#{a}.#{b}.#{c}.#{d}"
      end

    domain =
      case Host.reverse_lookup(ip: ip) do
        {:ok, d} -> d
        {:error, _} -> "No Domain"
      end

    answer =
      case Redirector.preferred_visitor?(domain: domain) do
        true ->
          "yes"

        false ->
          "no"
      end

    content = %{
      "is_preferred_visitor" => answer,
      "remote_ip" => ip,
      "remote_domain" => domain
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
end
