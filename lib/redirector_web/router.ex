defmodule RedirectorWeb.Router do
  use RedirectorWeb, :router

  pipeline :redirects do
    plug(:accepts, ["html"])
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", RedirectorWeb do
    pipe_through(:api)

    get("/is_preferred_visitor", ApiController, :is_preferred_visitor)
  end

  scope "/", RedirectorWeb do
    pipe_through(:redirects)

    get("/", RedirectController, :redirect_root)
    get("/*segments", RedirectController, :redirect_state)
  end
end
