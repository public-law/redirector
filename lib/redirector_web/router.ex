defmodule RedirectorWeb.Router do
  use RedirectorWeb, :router

  pipeline :redirects do
    plug(:accepts, ["html", "json"])
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", RedirectorWeb do
    pipe_through(:api)

    get("/debug", ApiController, :debug)
  end

  scope "/", RedirectorWeb do
    pipe_through(:redirects)

    # Static routes

    get("/sitemap.xml.gz", RedirectController, :sitemap)
    get("/robots.txt", RedirectController, :www_redirect)
    get("/rss", RedirectController, :rss)
    get("/blog/feed/", RedirectController, :blog_feed)
    get("/robb/feed/", RedirectController, :robb_blog_feed)
    get("/", RedirectController, :root)

    #
    # oregonlaws.org
    #
    get("/page", RedirectController, :ors_search)
    get("/oregon_revised_statutes", RedirectController, :ors_statutes)
    get("/ors/volume/:number", RedirectController, :ors_volume)
    get("/ors/chapter/:number", RedirectController, :ors_chapter)
    get("/ors_chapters/:number", RedirectController, :ors_chapter)
    get("/ors/:number", RedirectController, :ors_section)
    # With year
    get("/ors/:year/:number", RedirectController, :ors_section)
    get("/ors/:year/chapter/:number", RedirectController, :ors_chapter)

    #
    # Glossary
    #
    get("/glossary", RedirectController, :glossary_root)
    get("/glossary/definition/:phrase", RedirectController, :glossary_definition)

    #
    # weblaws.org
    #
    get("/states/*segments", RedirectController, :old_format)
    get("/*segments", RedirectController, :state)

    # Bad requests

    post("/*ignored", RedirectController, :bad_request)
  end
end
