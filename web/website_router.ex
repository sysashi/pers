defmodule Pers.WebsiteRouter do
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

  scope "/", Pers do
    pipe_through :browser # Use the default browser stack

    resources "/notes", NoteController, only: [:index, :show] 
    resources "/projects", ProjectController, only: [:index, :show] 
    
    get "/", PageController, :index
    get "/:page", PageController, :index

  end

end
