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
  end

  scope "/", alias: Pers, host: "admin." do
    forward "/", AdminRouter
  end


  scope "/", Pers do
    pipe_through :browser # Use the default browser stack

    get "/*page", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Pers do
  #   pipe_through :api
  # end
end
