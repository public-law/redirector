defmodule RedirectorWeb.RedirectControllerTest do
  use RedirectorWeb.ConnCase

  test "redirect_root/2 sends to www.public.law", %{conn: conn} do
    conn = get(conn, "/")

    assert conn.status == 301
    assert get_resp_header(conn, "location") == ["https://www.public.law"]
  end
end
