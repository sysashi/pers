defmodule Pers.Repo.Migrations.CreatePage do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :string
      add :link, :string
      add :html, :text
      add :markdown, :text
      add :published_at, :datetime

      timestamps
    end

    create unique_index(:pages, [:link])
  end
end
