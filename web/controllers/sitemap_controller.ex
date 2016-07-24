defmodule Pers.SitemapController do
  use Pers.Web, :controller
  alias Pers.{Note, Page}

  def sitemap(conn, _params) do
    notes = Note.notes_sitemap
      |> Repo.all
    pages = Page.pages_sitemap
      |> Repo.all

    render conn, "all.xml", 
      notes: notes,
      pages: pages
  end
end
