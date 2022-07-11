defmodule RedirectorWeb.ApiControllerTest do
  @moduledoc """
  Tests for the Preferred user API.
  """

  use RedirectorWeb.ConnCase

  test "basic request is not preferred", %{conn: conn} do
    conn = get(conn, "/api/is_preferred_visitor")
    response = json_response(conn, 200)

    assert %{"is_preferred_visitor" => "no"} = response
  end
end
