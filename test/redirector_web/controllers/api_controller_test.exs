defmodule RedirectorWeb.ApiControllerTest do
  use RedirectorWeb.ConnCase

  test "basic request is not preferred", %{conn: conn} do
    conn = get(conn, "/api/is_preferred_visitor")
    assert conn.status == 200
  end
end
