defmodule RedirectorWeb.RedirectControllerTest do
  @moduledoc """
  Test the redirect function.
  """
  use RedirectorWeb.ConnCase

  #
  # Searches
  #
  test "An oregonlaws search", %{conn: conn} do
    conn = get(conn, "/page?page=24&search=filing+fee")
    expected = "https://oregon.public.law/search?page=24&term=filing+fee"

    assert conn.status == 301
    assert get_resp_header(conn, "location") == [expected]
  end

  test "An oregonlaws search without page", %{conn: conn} do
    conn = get(conn, "/page?search=probate")
    expected = "https://oregon.public.law/search?term=probate"

    assert conn.status == 301
    assert get_resp_header(conn, "location") == [expected]
  end

  test "An oregonlaws search with object filter", %{conn: conn} do
    conn = get(conn, "/page?object_filter=36&page=15&search=access")
    expected = "https://oregon.public.law/search?page=15&term=access"

    assert conn.status == 301
    assert get_resp_header(conn, "location") == [expected]
  end

  #
  # General
  #

  test "Catch-all for GET", %{conn: conn} do
    conn = get(conn, "/statutes/ors_316.003")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://oregon.public.law/statutes/ors_316.003"]
  end

  test "Catch-all works with weird stuff", %{conn: conn} do
    conn = get(conn, "/1/2/3/4/5.txt")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://oregon.public.law/1/2/3/4/5.txt"]
  end

  test "Catch-all works with just one word", %{conn: conn} do
    conn = get(conn, "/robb")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://oregon.public.law/robb"]
  end

  test "Catch-all works with older volume path", %{conn: conn} do
    conn = get(conn, "/ors/2011/volume/14")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://oregon.public.law/ors/2011/volume/14"]
  end

  test "Sign-in goes to the new site", %{conn: conn} do
    conn = get(conn, "/users/sign_in")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://oregon.public.law/users/sign_in"]
  end

  test "ads.txt goes to new site", %{conn: conn} do
    conn = get(conn, "/ads.txt")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://oregon.public.law/ads.txt"]
  end

  test "Sitemap goes to new site", %{conn: conn} do
    conn = get(conn, "/sitemap.xml.gz")

    assert conn.status == 301

    assert get_resp_header(conn, "location") == [
             "https://oregon.public.law/sitemaps/sitemap.xml.gz"
           ]
  end

  #
  # Blog
  #

  test "Blog page goes to the correct site", %{conn: conn} do
    conn = get(conn, "/blog/2009/08/how-does-oregonlawsorg-work")

    assert conn.status == 301

    assert get_resp_header(conn, "location") == [
             "https://blog.public.law/2009/08/how-does-oregonlawsorg-work/"
           ]
  end

  test "Blog feed goes to new blog location", %{conn: conn} do
    conn = get(conn, "/blog/feed/")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://blog.public.law/feed/"]
  end

  test "Blog rss", %{conn: conn} do
    conn = get(conn, "/rss")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://blog.public.law/rss"]
  end

  test "Robb's blog feed goes to new blog location", %{conn: conn} do
    conn = get(conn, "/robb/feed/")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://dogsnog.blog/feed/"]
  end

  #
  # Other
  #

  test "A simple page redirect", %{conn: conn} do
    conn = get(conn, "/robots.txt")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://www.public.law/robots.txt"]
  end

  #
  # Bad requests
  #
  test "POST requests to root (1) are 400", %{conn: conn} do
    conn = post(conn, "")

    assert conn.status == 400
  end

  test "POST requests to root (2) are 400", %{conn: conn} do
    conn = post(conn, "/")

    assert conn.status == 400
  end

  test "POST requests to a path are 400", %{conn: conn} do
    conn = post(conn, "/1")

    assert conn.status == 400
  end

  #
  # Glossary Redirects
  #

  test "Glossary redirects", %{conn: conn} do
    conn = get(conn, "/glossary/definition/alternate_juror")

    assert conn.status == 301

    assert get_resp_header(conn, "location") == [
             "https://www.public.law/dictionary/entries/alternate-juror"
           ]
  end

  test "Glossary root", %{conn: conn} do
    conn = get(conn, "/glossary")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://www.public.law/dictionary"]
  end

  #
  # ORS Redirects
  #

  test "ORS home page goes to the right place", %{conn: conn} do
    conn = get(conn, "http://www.oregonlaws.org/")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://oregon.public.law"]
  end

  test "ORS statutes goes to the right place", %{conn: conn} do
    conn = get(conn, "/oregon_revised_statutes")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://oregon.public.law/statutes"]
  end

  test "ORS Volume request", %{conn: conn} do
    conn = get(conn, "/ors/volume/6")

    assert conn.status == 301

    assert get_resp_header(conn, "location") == [
             "https://oregon.public.law/statutes/ors_volume_6"
           ]
  end

  test "ORS Chapter request", %{conn: conn} do
    conn = get(conn, "/ors/chapter/6")

    assert conn.status == 301

    assert get_resp_header(conn, "location") == [
             "https://oregon.public.law/statutes/ors_chapter_6"
           ]
  end

  test "Alternate ORS Chapter request", %{conn: conn} do
    conn = get(conn, "/ors_chapters/352")

    assert conn.status == 301

    assert get_resp_header(conn, "location") == [
             "https://oregon.public.law/statutes/ors_chapter_352"
           ]
  end

  test "ORS Section request", %{conn: conn} do
    conn = get(conn, "/ors/123.456")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://oregon.public.law/statutes/ors_123.456"]
  end

  test "ORS Section with year", %{conn: conn} do
    conn = get(conn, "/ors/2007/497.040")

    assert(conn.status == 301)
    assert get_resp_header(conn, "location") == ["https://oregon.public.law/statutes/ors_497.040"]
  end

  test "ORS Chapter with year", %{conn: conn} do
    conn = get(conn, "/ors/2013/chapter/777")

    assert(conn.status == 301)

    assert get_resp_header(conn, "location") == [
             "https://oregon.public.law/statutes/ors_chapter_777"
           ]
  end

  #
  # Weblaws.org Redirects
  #

  test "redirect_root/2 sends to www.public.law", %{conn: conn} do
    conn = get(conn, "http://www.weblaws.org/")

    assert conn.status == 301

    assert get_resp_header(conn, "location") == [
             "https://www.public.law"
           ]
  end

  test "basic state redirect", %{conn: conn} do
    conn = get(conn, "/texas/statutes/tex._election_code")

    assert conn.status == 301

    assert get_resp_header(conn, "location") == [
             "https://texas.public.law/statutes/tex._election_code"
           ]
  end

  test "leaf node New York redirect", %{conn: conn} do
    conn = get(conn, "/new_york/laws/n.y._multiple_dwelling_law_section_2")

    assert conn.status == 301

    assert get_resp_header(conn, "location") == [
             "https://newyork.public.law/laws/n.y._multiple_dwelling_law_section_2"
           ]
  end

  test "leaf node California redirect", %{conn: conn} do
    conn = get(conn, "/california/codes/ca_sts_and_high_code_div_1_chap_1.5")

    assert conn.status == 301

    assert get_resp_header(conn, "location") == [
             "https://california.public.law/codes/ca_sts_and_high_code_div_1_chap_1.5"
           ]
  end

  test "very old-style california redirect", %{conn: conn} do
    conn = get(conn, "/states/california/statutes/ca_penal_section_459")

    assert conn.status == 301

    assert get_resp_header(conn, "location") == [
             "https://california.public.law/codes/ca_penal_code_section_459"
           ]
  end
end
