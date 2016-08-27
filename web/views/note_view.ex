defmodule Pers.NoteView do
  use Pers.Web, :view

  def group_by(notes, date: date) do
    funs = Enum.map(date, fn fun when is_atom(fun) ->
      &apply(__MODULE__, fun, [&1])
    end) 
    
    group_by(notes, funs)
  end

  def group_by(list, fun) when is_function(fun) do
    group_by(list, List.wrap(fun))
  end

  def group_by(list, funs) when is_list(list) and is_list(funs) do
    Enum.reduce(list, [], fn entry, acc -> 
      insert(acc, {entry, level(entry, funs)})
    end)
  end

  def map_grouped_notes(list, fun) do
    traverse_map(list, fun)
  end

  def insert(list, {value, level}) do
    insert(list, value, level)
  end

  defp insert(list, value, [level | rest] = levels) do
    case List.keyfind(list, level, 0) do
      nil -> 
        v = wrap(value, levels |> Enum.reverse())
        List.keystore(list, level, 0, v)
      {key, [{_, _} | _] = data} when is_list(data) -> 
        x = insert(data, value, rest)
        List.keystore(list, key, 0, {key, x})
      {key, data} when is_list(data) ->
        List.keystore(list, key, 0, {key, [value | data]})
    end
  end

  defp traverse_map(notes, fun, ctx \\ {[], []})

  defp traverse_map([], _fun, {_level, acc}), do: acc

  defp traverse_map([{key, list} | rest], fun, {level, acc}) when is_list(list) do
    depth = traverse_map(list, fun, {[key | level], acc})
    traverse_map(rest, fun, {level, depth})
  end

  defp traverse_map([v | values], fun, {level, acc}) do 
    acc = insert(acc, {fun.(v), level |> Enum.reverse()}) 
    traverse_map(values, fun, {level, acc})
  end

  defp wrap(value, []), do: value

  defp wrap(value, [level | levels]) do
    wrap({level, [value]}, levels)
  end

  defp level(note, funs) do
    Enum.reduce(funs, [], fn fun, acc -> 
      [fun.(note) | acc]
    end)
    |> Enum.reverse()
  end

  def by_year(%{published_at: %{year: year}}), do: year
  def by_month(%{published_at: %{month: month}}), do: month_name(month)
end
