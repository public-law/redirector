defmodule RedirectorWeb.RedirectController do
  use RedirectorWeb, :controller

  @collection_names %{
    "california" => "codes",
    "newyork" => "laws",
    "texas" => "statutes"
  }

  @opl_url "https://oregon.public.law"
  @www_url "https://www.public.law"
  @blg_url "https://blog.public.law"

  #
  # General requests
  #

  def bad_request(conn, _) do
    conn
    |> put_status(400)
    |> text("Error")
  end

  #
  # Blog
  #

  def blog_feed(conn, _),      do: perm_redirect(conn, to: "#{@blg_url}/feed/")
  def rss(conn, _),            do: perm_redirect(conn, to: "#{@blg_url}/rss")
  def robb_blog_feed(conn, _), do: perm_redirect(conn, to: "https://dogsnog.blog/feed/")

  #
  # Other static routes
  #

  def sitemap(conn, _),      do: perm_redirect(conn, to: "#{@opl_url}/sitemaps/sitemap.xml.gz")
  def ors_statutes(conn, _), do: perm_redirect(conn, to: "#{@opl_url}/statutes")

  def www_redirect(conn, _), do: perm_redirect(conn, to: "#{@www_url}#{conn.request_path}")
  def opl_redirect(conn, _), do: perm_redirect(conn, to: "#{@opl_url}#{conn.request_path}")

  #
  # oregonlaws.org Redirects
  #

  #
  # Glossary
  #

  def glossary_definition(conn, %{"phrase" => phrase}) do
    fixed_up_phrase = String.replace(phrase, "_", "-")
    perm_redirect(conn, to: "#{@www_url}/dictionary/entries/#{fixed_up_phrase}")
  end

  def glossary_root(conn, _), do: perm_redirect(conn, to: "#{@www_url}/dictionary")

  #
  # Other
  #

  def ors_volume(conn, %{"number" => number}) do
    perm_redirect(conn, to: "#{@opl_url}/statutes/ors_volume_#{number}")
  end

  def ors_chapter(conn, %{"number" => number}) do
    perm_redirect(conn, to: "#{@opl_url}/statutes/ors_chapter_#{number}")
  end

  def ors_section(conn, %{"number" => number}) do
    perm_redirect(conn, to: "#{@opl_url}/statutes/ors_#{number}")
  end

  def ors_search(conn, %{"search" => term, "page" => page}) do
    query = URI.encode_query(%{page: page, term: term})
    perm_redirect(conn, to: "#{@opl_url}/search?#{query}")
  end

  def ors_search(conn, %{"search" => term}) do
    query = URI.encode_query(%{term: term})
    perm_redirect(conn, to: "#{@opl_url}/search?#{query}")
  end

  #
  # Root path Redirects
  #

  def root(conn = %{host: "www.oregonlaws.org"}, _), do: perm_redirect(conn, to: @opl_url)
  def root(conn = %{host: "oregonlaws.org"}, _),     do: perm_redirect(conn, to: @opl_url)
  def root(conn, _),                                 do: perm_redirect(conn, to: "#{@www_url}")

  #
  # Weblaws.org Redirects
  #

  def state(conn, %{"segments" => [state = "california" | tail]}),
    do: do_state_redirect(conn, state, tail)

  def state(conn, %{"segments" => [state = "new_york" | tail]}),
    do: do_state_redirect(conn, state, tail)

  def state(conn, %{"segments" => [state = "texas" | tail]}),
    do: do_state_redirect(conn, state, tail)

  def state(conn, %{"segments" => segments}),
    do: perm_redirect(conn, to: "#{@opl_url}/#{Enum.join(segments, "/")}")

  defp do_state_redirect(conn, state, segments) do
    domain = translate_state(state)
    path = Enum.join(segments, "/")

    perm_redirect(conn, to: "https://#{domain}.public.law/#{path}")
  end

  def old_format(conn, %{"segments" => [state, _collection, page]}) do
    domain = translate_state(state)

    corrected_page =
      if domain == "california" && !String.contains?(page, "code_section") do
        String.replace(page, "_section", "_code_section")
      else
        page
      end

    path = Enum.join([@collection_names[domain], corrected_page], "/")

    perm_redirect(conn, to: "https://#{domain}.public.law/#{path}")
  end

  defp translate_state(state) do
    case state do
      "new_york" -> "newyork"
      _ -> state
    end
  end

  defp perm_redirect(conn, to: url) do
    conn
    |> put_status(301)
    |> redirect(external: url)
  end
end
