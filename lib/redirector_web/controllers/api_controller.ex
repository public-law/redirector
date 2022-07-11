require Logger

defmodule RedirectorWeb.ApiController do
  use RedirectorWeb, :controller
  import Redirector

  @spec debug(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def debug(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, inspect(conn))
  end

  @spec is_preferred_visitor(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def is_preferred_visitor(conn, _params) do
    {remote_ip, remote_domain} = remote_info(conn)

    answer =
      case preferred_visitor?(domain: remote_domain) do
        true -> "yes"
        false -> "no"
      end

    json_content =
      Jason.encode!(%{
        "remote_ip" => remote_ip,
        "remote_domain" => remote_domain,
        "is_preferred_visitor" => answer
      })

    Logger.info(fn -> "#{json_content}" end)

    conn
    |> put_resp_content_type("text/json")
    |> send_resp(200, json_content)
  end

  @doc """
  Return the IP and domain of the request.
  """
  def remote_info(conn) do
    remote_ip =
      case x_forwarded_for(conn) do
        {:ok, addr} -> addr
        {:error, _} -> as_string(ip: conn.remote_ip)
      end

    remote_domain =
      case Host.ext_reverse_lookup(ip: remote_ip) do
        {:ok, domain} -> domain
        {:error, _} -> "No Domain"
      end

    {remote_ip, remote_domain}
  end

  def x_forwarded_for(conn) do
    case Enum.find(conn.req_headers, fn {k, _v} -> k == "x-forwarded-for" end) do
      {"x-forwarded-for", ip_string} -> {:ok, ip_string}
      nil -> {:error, "Not found"}
    end
  end

  def as_string(ip: {a, b, c, d}) do
    "#{a}.#{b}.#{c}.#{d}"
  end
end
