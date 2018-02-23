defmodule RedirectorWeb.Router do
  use RedirectorWeb, :router

  pipeline :redirects do
    plug(:accepts, ["html"])
  end

  scope "/", RedirectorWeb do
    pipe_through(:redirects)

    get("/", RedirectController, :redirect_root)
    get("/texas*segments", RedirectController, :redirect_texas)
    get("/new_york*segments", RedirectController, :redirect_newyork)
  end
end
