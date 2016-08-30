defmodule Pers.PageController do
  use Pers.Web, :controller

  def index(conn, _params) do
    data = [
      recent_notes: Note.recent(3)
      |> Repo.all()
      |> Repo.preload(:tags),

      recent_projects: Project.recent(5)
      |> Repo.all()
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
