# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pers.Repo.insert!(%Pers.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
defmodule Pers.Seed do
  alias Pers.{Repo, Note, Project, Log}
  
  @data %{
    titles:  ["My awesome title! And is quite \
    long and so far and so forth etc.", "test title"],
    texts: ["Lorem Ipsum Blalalalala"],
    logs: ["I dunno yet what logs gonna be fun"],
    p_names: ["my project 1", "another cool(maybe) project"]
  }

  def add_random_notes(n \\ 10) do
    for _ <- 1..n do
      note = %Note{
        title: random(@data.titles),
        html: somehtml(),
        published_at: random_date(5) 
      }
      Repo.insert!(note)
    end
  end

  def add_random_projects(n \\ 10) do
    for _ <- 1..n do
      note = %Project{
        name: random(@data.p_names),
        desc: random(@data.texts),
        published_at: random_date()
      }
      Repo.insert!(note)
    end

  end

  def add_random_logs(n \\ 20) do
    for _ <- 1..n do
      note = %Log{
        body: random(@data.logs),
      }
      Repo.insert!(note)
    end
  end

  defp random(list) do
    Enum.take_random(list, 1)
    |> hd()
  end

  defp random_date(range_years \\ 1) do
    year_range = (3600 * 24 * (365 * range_years))
    |> Kernel.*(:rand.uniform())
    |> Kernel.trunc()
    
    new_date = :calendar.local_time
    |> :calendar.datetime_to_gregorian_seconds
    |> Kernel.-(year_range)
    |> :calendar.gregorian_seconds_to_datetime
    |> Ecto.DateTime.from_erl()
  end

  defp somehtml do
    ~S"""
    <h2> Here is my note ! </h2>
    <strong> or somebody else's </strong>
    <p> AND A PARAGRAPH </p>
    """
  end
end


Pers.Seed.add_random_logs(28)
Pers.Seed.add_random_projects(7)
Pers.Seed.add_random_notes(17)
