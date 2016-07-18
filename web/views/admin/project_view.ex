defmodule Pers.Admin.ProjectView do
  use Pers.Web, :view

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, Pers.Admin.ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, Pers.Admin.ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id,
      name: project.name,
      links: project.links,
      desc: project.desc,
      status: project.status,
      inserted_at: project.inserted_at,
      updated_at: project.updated_at,
      published_at: project.published_at}
  end
end
