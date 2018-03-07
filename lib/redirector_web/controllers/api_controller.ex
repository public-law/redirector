defmodule RedirectorWeb.ApiController do
  use RedirectorWeb, :controller

  def is_preferred_visitor(conn, _params) do
    {a, b, c, d} = conn.remote_ip
    ip = "#{a}.#{b}.#{c}.#{d}"
    {:ok, domain} = Host.reverse_lookup(ip: ip)

    content = %{
      "is_preferred_visitor" => "no",
      "remote_ip" => ip,
      "remote_domain" => domain
    }

    # TODO: preferred_origin?(conn.remote_ip)

    conn
    |> put_resp_content_type("text/json")
    |> send_resp(200, Poison.encode!(content))
  end
end
