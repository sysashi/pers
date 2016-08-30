defmodule Pers.NoteViewTest do
  use Pers.ConnCase, async: true
  require Logger
  alias Pers.{Note, NoteView}
  import NoteView, only: [map_grouped_notes: 2, wrap_notes: 2]

  setup_all do
    dates = [~D[2015-01-31], ~D[2016-11-01], ~D[2016-08-23], ~D[2016-08-23]]
    notes =
      (for _ <- 1..4, do: %Note{})
      |> Enum.zip(dates)
      |> Enum.map(fn {n, d} -> %{n | published_at: d} end)
      |> Enum.sort(&(&1.published_at < &2.published_at))

    grouped_notes = 
      [{2016, [
        {11, [:note]},
        {8, [:note, :note]}
      ]},
      {2015, [
        {1, [:note]}
      ]}]

    {:ok, notes: notes, grouped_notes: grouped_notes}
  end

  test "grouping notes by year and month", context do
    funs = [&by_year/1, &by_month/1]
    result = NoteView.group_by(context.notes, funs)
    |> map_grouped_notes(fn _ -> :note end)

    assert context.grouped_notes == result
  end

  test "wrap grouped notes in html", context do
    fun = fn 
      list when is_list(list) -> 
        IO.inspect(list)
      other ->
        IO.inspect("class #{other}")
    end

    result = context.grouped_notes
    |> map_grouped_notes(fn _ -> "note" end)
    |> wrap_notes(fun)

    refute result
  end

  defp by_year(%{published_at: %{year: year}}), do: year
  defp by_month(%{published_at: %{month: month}}), do: month
end
