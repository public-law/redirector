defmodule RedirectorWeb.Router do
  use RedirectorWeb, :router

  pipeline :redirects do
    plug(:accepts, ["html"])
  end

  scope "/", RedirectorWeb do
    pipe_through(:redirects)

    get("/", RedirectController, :redirect_root)
  end
end
