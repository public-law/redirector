defmodule RedirectorWeb.ApiController do
  use RedirectorWeb, :controller

  def is_preferred_visitor(conn, _params) do
    conn |> put_status(200)
  end
end
