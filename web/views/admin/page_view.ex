defmodule Pers.Admin.PageView do
  use Pers.Web, :view

  def render("index.json", %{pages: pages}) do
    %{data: render_many(pages, Pers.Admin.PageView, "page.json")}
  end

  def render("show.json", %{page: page}) do
    %{data: render_one(page, Pers.Admin.PageView, "page.json")}
  end

  def render("page.json", %{page: page}) do
    %{id: page.id,
      title: page.title,
      link: page.link,
      html: page.html,
      markdown: page.markdown,
      published_at: page.published_at, 
      updated_at: page.updated_at,
      inserted_at: page.inserted_at}
  end
end
