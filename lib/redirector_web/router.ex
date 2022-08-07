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

    # Static routes

    get("/users/sign_in",  RedirectController, :sign_in)
    get("/ads.txt",        RedirectController, :ads_txt)
    get("/sitemap.xml.gz", RedirectController, :sitemap)
    get("/robots.txt",     RedirectController, :robots)
    get("/rss",            RedirectController, :redirect_rss)
    get("/blog/feed/",     RedirectController, :blog_feed)
    get("/robb/feed/",     RedirectController, :robb_blog_feed)
    get("/",               RedirectController, :redirect_root)

    #
    # oregonlaws.org
    #
    get("/page",                    RedirectController, :redirect_ors_search)
    get("/oregon_revised_statutes", RedirectController, :ors_statutes)
    get("/ors/volume/:number",      RedirectController, :redirect_ors_volume)
    get("/ors/chapter/:number",     RedirectController, :redirect_ors_chapter)
    get("/ors_chapters/:number",    RedirectController, :redirect_ors_chapter)
    get("/ors/:number",             RedirectController, :redirect_ors_section)
    # With year
    get("/ors/:year/:number",         RedirectController, :redirect_ors_section)
    get("/ors/:year/chapter/:number", RedirectController, :redirect_ors_chapter)

    #
    # Glossary
    #
    get("/glossary",                    RedirectController, :redirect_glossary_root)
    get("/glossary/definition/:phrase", RedirectController, :redirect_glossary_definition)

    #
    # weblaws.org
    #
    get("/states/*segments", RedirectController, :redirect_old_format)
    get("/*segments",        RedirectController, :redirect_state)

    # Bad requests

    post("/*ignored", RedirectController, :bad_request)
  end
end
