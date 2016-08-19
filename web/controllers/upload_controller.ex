defmodule Pers.UploadController do
  use Pers.Web, :controller

  def index(conn, params) do
    conn
    |> render("index.html")
  end

  def upload(conn, params) do
    IO.inspect params 
    Process.sleep(1_000)
  end
end
