defmodule RedirectorWeb.RedirectControllerTest do
  use RedirectorWeb.ConnCase

  test "redirect_root/2 sends to www.public.law", %{conn: conn} do
    conn = get(conn, "/")

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
end
