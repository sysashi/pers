defmodule Pers.NoteController do
  use Pers.Web, :controller
  alias Pers.Note

  @per_page 5

  def index(conn, params) do
    count = Pers.Repo.one!(Note.count_published)
    page_number = page_number(params["page"], 
                              count, 
                              @per_page) || 1
    offset = (@per_page * (page_number - 1))
    notes = Note.paged(@per_page, offset)
    |> Pers.Repo.all()

    data = [
      notes: notes,
      count: count,
      page_number: page_number,
      per_page: @per_page
    ]
    render(conn, "index.html", data)
  end

  def show(conn, %{"id" => id}) do
    note = Repo.get!(Note, id)
    render(conn, "show.html", note: note)
  end

  defp page_number(n, _count, _per_page) when is_integer(n)
  and n < 1, do: 1

  defp page_number(n, count, per_page) when is_integer(n) do
    last_page = (count / per_page)
    |> Float.ceil()
    |> Kernel.trunc()

    if n < last_page do
      n
    else
      last_page
    end
  end

  defp page_number(n, count, per_page) when is_binary(n) do
    case Integer.parse(n, 10) do
      {pn, _} -> pn
      :error -> nil
    end |> page_number(count, per_page)
  end

  defp page_number(_, _, _), do: nil
end
