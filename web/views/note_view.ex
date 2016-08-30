defmodule Pers.NoteView do
  use Pers.Web, :view

  def wrap_notes(notes, fun) do
    content_tag(:ul) do
      traverse(notes, fun, {[], 0})
    end
  end

  def group_by(list, date: date) do
    funs = Enum.map(date, fn fun when is_atom(fun) ->
      &apply(__MODULE__, fun, [&1])
    end) 
    
    group_by(list, funs)
  end

  def group_by(list, fun) when is_function(fun) do
    group_by(list, List.wrap(fun))
  end

  def group_by(list, funs) when is_list(list) and is_list(funs) do
    Enum.reduce(list, [], fn entry, acc -> 
      insert(acc, entry, level(entry, funs))
    end)
  end

  defp insert(list, value, [level | rest] = levels) do
    case List.keyfind(list, level, 0) do
      nil -> 
        value = wrap(value, levels |> Enum.reverse())
        List.keystore(list, level, 0, value)
      {key, [{_, _} | _] = data} when is_list(data) -> 
        right = insert(data, value, rest)
        List.keystore(list, key, 0, {key, right})
      {key, data} when is_list(data) ->
        List.keystore(list, key, 0, {key, [value | data]})
    end
  end

  def map_grouped_notes(list, fun) do
    traverse_map(list, fun)
  end

  defp traverse_map(notes, fun, ctx \\ {[], []})

  defp traverse_map([], _fun, {_level, acc}), do: acc

  defp traverse_map([{key, list} | rest], fun, {level, acc}) when is_list(list) do
    right = traverse_map(list, fun, {[key | level], acc})
    traverse_map(rest, fun, {level, right})
  end

  defp traverse_map([v | values], fun, {level, acc}) do 
    acc = insert(acc, fun.(v), level |> Enum.reverse()) 
    traverse_map(values, fun, {level, acc})
  end

  defp traverse([], _fun, {acc, _}), do: acc |> Enum.reverse()
  
  defp traverse([{key, list} | rest], fun, {acc, index}) when is_list(list) do 
    t = content_tag(:li, class: "nest-level-#{index}") do
      ~E"""
      <%= fun.({key, index}) %> 
      <%= content_tag(:ul, class: content_class(list)) do %>
        <%= traverse(list, fun, {[], index + 1}) %>
      <% end %>
      """
    end

    traverse(rest, fun, {[t | acc], index})
  end

  defp traverse(list, fun, acc) when is_list(list) do
    fun.(list) |> Enum.reverse()
  end


  defp wrap(value, []), do: value

  defp wrap(value, [h | t]) do
    wrap({h, [value]}, t)
  end

  defp level(note, funs) do
    funs
    |> Enum.reduce([], 
         fn fun, acc -> 
           [fun.(note) | acc]
         end)
    |> Enum.reverse()
  end

  defp content_class(list, class \\ "content") do
    class = case list do
      [{_, _} | _] ->
        nil
      list when is_list(list) -> class
    end
  end

  def by_year(%{published_at: %{year: year}}), do: year
  def by_month(%{published_at: %{month: month}}), do: month_name(month)
  def by_day(%{published_at: %{day: day}}), do: day
end
