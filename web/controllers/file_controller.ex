defmodule Pers.FileController do
  use Pers.Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def show(conn, params) do
    conn
    |> render("show.html")
  end
end
