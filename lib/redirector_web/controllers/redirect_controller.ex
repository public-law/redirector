defmodule RedirectorWeb.RedirectController do
  use RedirectorWeb, :controller

  def redirect_root(conn, _params) do
    conn
    |> put_status(301)
    |> redirect(external: "https://www.public.law")
    |> halt
  end
end
