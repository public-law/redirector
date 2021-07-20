defmodule RedirectorWeb.RedirectControllerTest do
  use RedirectorWeb.ConnCase

  test "A simple page redirect", %{conn: conn} do
    conn = get(conn, "/robots.txt")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://www.public.law/robots.txt"]
  end

  #
  # Unknown Paths
  #
  test "Unknown path is 404 - page", %{conn: conn} do
    conn = get(conn, "/snack?snack=11&search=registration")

    assert conn.status == 404
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

  test "ORS Section request", %{conn: conn} do
    conn = get(conn, "/ors/123.456")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://oregon.public.law/statutes/ors_123.456"]
  end

  # Temporarily redirect older ORS editions until we
  # add them to public.law.
  test "ORS Section with year", %{conn: conn} do
    conn = get(conn, "/ors/2007/497.040")

    assert(conn.status == 301)
    assert get_resp_header(conn, "location") == ["https://oregon.public.law/statutes/ors_497.040"]
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
