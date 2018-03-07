defmodule RedirectorWeb.ApiControllerTest do
  use RedirectorWeb.ConnCase

  test "basic request is not preferred", %{conn: conn} do
    conn = get(conn, "/api/is_preferred_visitor")
    assert json_response(conn, 200) == %{"is_preferred_visitor" => "no"}
  end
end
