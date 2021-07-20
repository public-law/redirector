defmodule RedirectorWeb.RedirectController do
  use RedirectorWeb, :controller

  @collection_names %{
    "california" => "codes",
    "newyork" => "laws",
    "texas" => "statutes"
  }

  @opl_url "https://oregon.public.law"

  #
  # General requests
  #

  def bad_request(conn, _params) do
    conn
    |> put_status(400)
    |> halt
  end

  #
  # oregonlaws.org Redirects
  #

  @spec redirect_ors_statutes(Plug.Conn.t(), any) :: Plug.Conn.t()
  def redirect_ors_statutes(conn, _params) do
    permanent_redirect(conn, to: "#{@opl_url}/statutes")
  end

  @spec redirect_ors_volume(Plug.Conn.t(), map) :: Plug.Conn.t()
  def redirect_ors_volume(conn, %{"number" => number}) do
    permanent_redirect(conn, to: "#{@opl_url}/statutes/ors_volume_#{number}")
  end

  @spec redirect_ors_chapter(Plug.Conn.t(), map) :: Plug.Conn.t()
  def redirect_ors_chapter(conn, %{"number" => number}) do
    permanent_redirect(conn, to: "#{@opl_url}/statutes/ors_chapter_#{number}")
  end

  @spec redirect_ors_section(Plug.Conn.t(), map) :: Plug.Conn.t()
  def redirect_ors_section(conn, %{"number" => number}) do
    permanent_redirect(conn, to: "#{@opl_url}/statutes/ors_#{number}")
  end

  #
  # Root path Redrects
  #

  @spec redirect_root(Plug.Conn.t(), any) :: Plug.Conn.t()
  def redirect_root(conn = %{host: "www.oregonlaws.org"}, _params) do
    permanent_redirect(conn, to: "https://oregon.public.law")
  end

  def redirect_root(conn = %{host: "oregonlaws.org"}, _params) do
    permanent_redirect(conn, to: "https://oregon.public.law")
  end

  def redirect_root(conn, _params) do
    permanent_redirect(conn, to: "https://www.public.law")
  end

  #
  # Weblaws.org Redirects
  #

  @spec redirect_state(Plug.Conn.t(), map) :: Plug.Conn.t()
  def redirect_state(conn, %{"segments" => [state | tail]}) do
    domain = translate_state(state)
    path = Enum.join(tail, "/")

    permanent_redirect(conn, to: "https://#{domain}.public.law/#{path}")
  end

  @spec redirect_old_format(Plug.Conn.t(), map) :: Plug.Conn.t()
  def redirect_old_format(conn, %{"segments" => [state, _collection, page]}) do
    domain = translate_state(state)

    corrected_page =
      if domain == "california" && !String.contains?(page, "code_section") do
        String.replace(page, "_section", "_code_section")
      else
        page
      end

    path = Enum.join([@collection_names[domain], corrected_page], "/")

    permanent_redirect(conn, to: "https://#{domain}.public.law/#{path}")
  end

  defp translate_state(state) do
    case state do
      "new_york" -> "newyork"
      _ -> state
    end
  end

  defp permanent_redirect(conn, to: url) do
    conn
    |> put_status(301)
    |> redirect(external: url)
    |> halt
  end
end
