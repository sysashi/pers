defmodule Pers.AdminRouter do
  use Pers.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :admin_layout
  end

  pipeline :api do
    plug :fetch_session
    plug :fetch_flash
    plug :accepts, ["json"]
  end


  scope "/", Pers.Admin do
    pipe_through :browser

    get "/", Dashboard, :login_form
    post "/login", Dashboard, :login
    get "/logout", Dashboard, :logout
  end

  scope "/dashboard/", Pers.Admin do
    pipe_through [:browser,
     :ensure_admin]

   get "/", Dashboard, :index
  end

  scope "/api", Pers.Admin do
    pipe_through [:api, :ensure_admin]

    resources "/logs", LogController
    resources "/notes", NoteController
    resources "/pages", PageController
    resources "/projects", ProjectController
  end

  defp ensure_admin(conn, _params) do
    case get_session(conn, :login) do
      %Pers.Admin{} = admin ->
        conn
        _ -> 
        halt(conn)
    end
  end

  @admin_layout "admin_layout.html"
  defp admin_layout(conn, _params) do
    put_layout(conn, {Pers.AdminView, @admin_layout})
  end
end
