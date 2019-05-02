defmodule Outliner.OutlinerTest do
  use ExUnit.Case, async: true

  test "the test file works" do
    assert 1 + 1 == 2
  end

  test "handles the null case" do
    non_outline = ['<p>Nothing here.</p>']
    section_form = ['<section class="level-0 non-meta non-outline">Nothing here.</section>']

    assert Outliner.or_oar(non_outline) == section_form
  end
end
