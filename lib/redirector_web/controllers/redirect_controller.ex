defmodule RedirectorWeb.RedirectController do
  use RedirectorWeb, :controller

  def redirect_root(conn, _params) do
    conn
    |> put_status(301)
    |> redirect(external: "https://www.public.law")
    |> halt
  end

  def redirect_texas(conn, %{"segments" => ["texas" | t]}) do
    conn
    |> put_status(301)
    |> redirect(external: "https://texas.public.law/#{Enum.join(t, "/")}")
    |> halt
  end

  def redirect_newyork(conn, %{"segments" => ["new_york" | t]}) do
    conn
    |> put_status(301)
    |> redirect(external: "https://newyork.public.law/#{Enum.join(t, "/")}")
    |> halt
  end
end
