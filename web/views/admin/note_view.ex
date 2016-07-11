defmodule Pers.Admin.NoteView do
  use Pers.Web, :view

  def render("index.json", %{notes: notes}) do
    %{data: render_many(notes, Pers.Admin.NoteView, "note.json")}
  end

  def render("show.json", %{note: note}) do
    %{data: render_one(note, Pers.Admin.NoteView, "note.json")}
  end

  def render("note.json", %{note: note}) do
    %{id: note.id,
      title: note.title,
      link: note.link,
      html: note.html,
      markdown: note.markdown,
      published_at: note.published_at}
  end
end
