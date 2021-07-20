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
    get("/debug", ApiController, :debug)
  end


  scope "/", RedirectorWeb do
    pipe_through(:redirects)

    get "/robots.txt", RedirectController, :redirect_robots
    get "/blog/feed/", RedirectController, :blog_feed

    get("/", RedirectController, :redirect_root)

    # oregonlaws.org

    get("/page", RedirectController, :redirect_ors_search)
    get("/oregon_revised_statutes", RedirectController, :redirect_ors_statutes)
    get("/ors/volume/:number", RedirectController, :redirect_ors_volume)
    get("/ors/chapter/:number", RedirectController, :redirect_ors_chapter)
    get("/ors/:number", RedirectController, :redirect_ors_section)
    get("/ors/:year/:number", RedirectController, :redirect_ors_section)

    # weblaws.org

    get("/states/*segments", RedirectController, :redirect_old_format)
    get("/*segments", RedirectController, :redirect_state)

    # Bad requests

    post("/*ignored", RedirectController, :bad_request)
  end
end
