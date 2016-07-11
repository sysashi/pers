defmodule Pers.ProjectController do
  use Pers.Web, :controller

  alias Pers.Project

  def index(conn, _params) do
    projects = Repo.all(Project)
    render(conn, "index.html", projects: projects)
  end

  def show(conn, %{"id" => id}) do
    project = Repo.get!(Project, id)
    render(conn, "show.html", project: project)
  end
end
