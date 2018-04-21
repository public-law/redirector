defmodule RedirectorWeb.RedirectController do
  use RedirectorWeb, :controller

  def redirect_root(conn, _params) do
    conn
    |> put_status(301)
    |> redirect(external: "https://www.public.law")
    |> halt
  end

  def redirect_state(conn, %{"segments" => [state | tail]}) do
    domain =
      case state do
        "new_york" -> "newyork"
        _ -> state
      end

    path = Enum.join(tail, "/")

    conn
    |> put_status(301)
    |> redirect(external: "https://#{domain}.public.law/#{path}")
    |> halt
  end

  def redirect_old_format(conn, %{"segments" => [state, _collection, page]}) do
    domain =
      case state do
        "new_york" -> "newyork"
        _ -> state
      end

    collection_names = %{
      "california" => "codes",
      "newyork" => "laws",
      "texas" => "statutes"
    }

    corrected_page =
      if domain == "california" && !String.contains?(page, "code_section") do
        String.replace(page, "_section", "_code_section")
      else
        page
      end

    path = Enum.join([collection_names[domain], corrected_page], "/")

    conn
    |> put_status(301)
    |> redirect(external: "https://#{domain}.public.law/#{path}")
    |> halt
  end
end
