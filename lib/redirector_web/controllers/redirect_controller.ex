defmodule RedirectorWeb.RedirectController do
  use RedirectorWeb, :controller

  @collection_names %{
    "california" => "codes",
    "newyork" => "laws",
    "texas" => "statutes"
  }


  def redirect_ors_root(conn, _params) do
    permanent_redirect(conn, to: "https://oregon.public.law/statutes")
  end

  def redirect_root(conn, _params) do
    permanent_redirect(conn, to: "https://www.public.law")
  end

  def redirect_state(conn, %{"segments" => [state | tail]}) do
    domain = translate_state(state)
    path = Enum.join(tail, "/")

    permanent_redirect(conn, to: "https://#{domain}.public.law/#{path}")
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

    permanent_redirect(conn, to: "https://#{domain}.public.law/#{path}")
  end

  defp translate_state(state) do
    case state do
      "new_york" -> "newyork"
      _ -> state
    end
  end

  defp permanent_redirect(conn, to: url) do
    conn
    |> put_status(301)
    |> redirect(external: url)
    |> halt
  end
end
