defmodule Pers.Admin.DashboardController do
  use Pers.Web, :controller 

  plug Pers.AdminAuth.EnsureAdmin

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
