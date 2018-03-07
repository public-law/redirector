defmodule RedirectorWeb.ApiController do
  use RedirectorWeb, :controller

  def debug(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, inspect(conn))
  end

  def is_preferred_visitor(conn, _params) do
    {a, b, c, d} = conn.remote_ip
    ip = "#{a}.#{b}.#{c}.#{d}"
    {:ok, domain} = Host.reverse_lookup(ip: ip)

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
end
