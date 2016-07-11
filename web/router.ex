defmodule Pers.Router do
  use Pers.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug :admin_layout
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/admin" do
    forward "/", Pers.AdminRouter
  end

  scope "/", alias: Pers do
    pipe_through :browser

    resources "/notes", NoteController, only: [:index, :show] 
    resources "/projects", ProjectController, only: [:index, :show] 
    
    get "/", PageController, :index
    get "/:page", PageController, :show
  end


  defp ensure_admin(conn, params) do
    conn
  end
  
  @admin_layout "admin_layout.html"
  defp admin_layout(conn, _params) do
    put_layout(conn, {Pers.AdminView, @admin_layout})
  end
end
