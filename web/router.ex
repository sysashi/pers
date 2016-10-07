defmodule Pers.Router do
  use Pers.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/admin", Pers.Admin do
    scope "/" do
      pipe_through [:browser, Pers.Common.AdminLayout]

      get "/", SessionController, :login_page
      post "/login", SessionController, :create
      get "/logout", SessionController, :delete

      scope "/dashboard" do
        get "/", DashboardController, :index
      end
    end

    scope "/api", as: "admin" do
      pipe_through [:api, Pers.AdminAuth.EnsureAdmin]

      resources "/notes", NoteController
      resources "/pages", PageController
      resources "/projects", ProjectController
      # TODO
      # resources "/files", FileController
      # post "/file_upload", FileUploadController, :upload
    end
  end

  scope "/", Pers do
    pipe_through :browser

    resources "/notes", NoteController, only: [:index, :show]
    resources "/projects", ProjectController, only: [:index, :show]
    # TODO
    # resources "/files", FileController, only: [:index, :show]

    get "/sitemap.xml", SitemapController, :sitemap
    get "/", PageController, :index
    get "/:page", PageController, :show
  end
end
