defmodule Pers.PageController do
  use Pers.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
