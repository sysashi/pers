defmodule Pers.ViewHelpers do
  def simple_time(nil), do: nil
  def simple_time(%Ecto.DateTime{} = time) do
    time
    |> Ecto.DateTime.to_date
    |> Ecto.Date.to_iso8601
  end

  def rel_from_now(nil), do: nil
  def rel_from_now(time) do
    now = Ecto.DateTime.utc
    diff_time = timediff(time, now)
    _rel(diff_time)
  end

  defp _rel({{0, 1, 1}, {0, 0, sec}}) do
    "Less then a minute ago"
  end
  defp _rel({{0, 1, 1}, {0, min, _sec}}) when min < 30 do
    "Half an hour ago"
  end
  defp _rel({{0, 1, 1}, {hour, _min, _sec}})  when hour < 2 do
    "An hour ago"
  end
  defp _rel({{0, 1, 1}, {hour, _min, _sec}}) do
    "#{hour} hours ago"
  end
  defp _rel({{0, 1, day}, {_hour, _min, _sec}}) when day < 2 do
    "A day ago"
  end
  defp _rel({{0, 1, day}, {_hour, _min, _sec}}) do
    "#{day} days ago"
  end
  defp _rel({{0, month, _day}, {_hour, _min, _sec}}) when month == 1 do
    "A month ago"
  end
  defp _rel({{0, month, _day}, {_hour, _min, _sec}}) do
    "#{month} months ago"
  end
  defp _rel({{year, _month, _day}, {_hour, _min, _sec}}) when year == 1 do
    "A year ago"
  end
  defp _rel({{year, _month, _day}, {_hour, _min, _sec}}) do
    "#{year} years ago"
  end
  
  defp timediff(time1, time2) do
    [sec1 | [sec2 | _ ]] = Enum.map [time1, time2], fn t ->
      Ecto.DateTime.to_erl(t)
      |> :calendar.datetime_to_gregorian_seconds()
    end

    Kernel.abs(sec2 - sec1)
    |> :calendar.gregorian_seconds_to_datetime()
  end
end
