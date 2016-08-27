defmodule Pers.NoteController do
  use Pers.Web, :controller

  def index(conn, _params) do
    notes = 
      Note.published   
      |> Repo.all()

    render(conn, "index.html", notes: notes)
  end

  def show(conn, %{"id" => id}) do
    note = Repo.get!(Note, id)
    render(conn, "show.html", note: note)
  end
end
