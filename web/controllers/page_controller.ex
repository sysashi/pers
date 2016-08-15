defmodule Pers.PageController do
  use Pers.Web, :controller

  def index(conn, _params) do
    data = [
      recent_notes: Repo.all(Note.recent(5)), 
      recent_projects: Repo.all(Project.recent(5)),
    ]
    render conn, "index.html", data
  end

  def show(conn, %{"page" => page_link}) do
    case Repo.get_by(Pers.Page, link: page_link) do
      nil -> 
        conn
        |> put_layout(false)
        |> put_status(:not_found)
        |> render(Pers.ErrorView, "404.html")
      page ->
        conn
        |> render("show.html", page: page)
    end
  end
end
