defmodule RedirectorWeb.RedirectController do
  use RedirectorWeb, :controller

  @collection_names %{
    "california" => "codes",
    "newyork" => "laws",
    "texas" => "statutes"
  }

  @opl_url "https://oregon.public.law"
  @www_url "https://www.public.law"

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

  def blog_feed(conn, _),      do: perm_redirect(conn, to: "https://blog.public.law/feed/")
  def redirect_rss(conn, _),   do: perm_redirect(conn, to: "https://blog.public.law/rss")
  def robb_blog_feed(conn, _), do: perm_redirect(conn, to: "https://dogsnog.blog/feed/")

  #
  # Other static routes
  #

  def redirect_robots(conn, _),  do: perm_redirect(conn, to: "#{@www_url}/robots.txt")
  def redirect_ads_txt(conn, _), do: perm_redirect(conn, to: "#{@opl_url}/ads.txt")
  def redirect_sign_in(conn, _), do: perm_redirect(conn, to: "#{@opl_url}/users/sign_in")
  def redirect_sitemap(conn, _), do: perm_redirect(conn, to: "#{@opl_url}/sitemaps/sitemap.xml.gz")


  #
  # oregonlaws.org Redirects
  #

  #
  # Glossary
  #

  def redirect_glossary_definition(conn, %{"phrase" => phrase}) do
    fixed_up_phrase = String.replace(phrase, "_", "-")
    perm_redirect(conn, to: "#{@www_url}/dictionary/entries/#{fixed_up_phrase}")
  end

  def redirect_glossary_root(conn, _), do: perm_redirect(conn, to: "#{@www_url}/dictionary")

  #
  # Other
  #

  def redirect_ors_statutes(conn, _), do: perm_redirect(conn, to: "#{@opl_url}/statutes")

  def redirect_ors_volume(conn, %{"number" => number}) do
    perm_redirect(conn, to: "#{@opl_url}/statutes/ors_volume_#{number}")
  end

  def redirect_ors_chapter(conn, %{"number" => number}) do
    perm_redirect(conn, to: "#{@opl_url}/statutes/ors_chapter_#{number}")
  end

  def redirect_ors_section(conn, %{"number" => number}) do
    perm_redirect(conn, to: "#{@opl_url}/statutes/ors_#{number}")
  end


  def redirect_ors_search(conn, %{"search" => term, "page" => page}) do
    query = URI.encode_query(%{page: page, term: term})
    perm_redirect(conn, to: "#{@opl_url}/search?#{query}")
  end

  def redirect_ors_search(conn, %{"search" => term}) do
    query = URI.encode_query(%{term: term})
    perm_redirect(conn, to: "#{@opl_url}/search?#{query}")
  end

  #
  # Root path Redirects
  #

  def redirect_root(conn = %{host: "www.oregonlaws.org"}, _), do: perm_redirect(conn, to: @opl_url)
  def redirect_root(conn = %{host: "oregonlaws.org"}, _),     do: perm_redirect(conn, to: @opl_url)
  def redirect_root(conn, _),                                 do: perm_redirect(conn, to: "#{@www_url}")

  #
  # Weblaws.org Redirects
  #

  def redirect_state(conn, %{"segments" => [state = "california" | tail]}),
    do: do_state_redirect(conn, state, tail)

  def redirect_state(conn, %{"segments" => [state = "new_york" | tail]}),
    do: do_state_redirect(conn, state, tail)

  def redirect_state(conn, %{"segments" => [state = "texas" | tail]}),
    do: do_state_redirect(conn, state, tail)

  def redirect_state(conn, %{"segments" => segments}),
    do: perm_redirect(conn, to: "#{@opl_url}/#{Enum.join(segments, "/")}")

  defp do_state_redirect(conn, state, segments) do
    domain = translate_state(state)
    path = Enum.join(segments, "/")

    perm_redirect(conn, to: "https://#{domain}.public.law/#{path}")
  end

  def redirect_old_format(conn, %{"segments" => [state, _collection, page]}) do
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
