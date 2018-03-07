defmodule Redirector.RedirectorTest do
  use RedirectorWeb.ConnCase

  test "localhost is not preferred" do
    assert Redirector.preferred_visitor?(domain: "localhost") == false
  end
end
