defmodule RedirectorWeb.ApiController do
  use RedirectorWeb, :controller

  def is_preferred_visitor(conn, _params) do
    conn
    |> put_resp_content_type("text/json")
    |> send_resp(200, "{\"is_preferred_visitor\": \"no\"}")
  end
end
