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
end
