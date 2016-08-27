defmodule Pers.Repo.Migrations.CreateNote do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :title, :string
      add :html, :text
      add :markdown, :text
      add :link, :string
      add :published_at, :datetime

      timestamps
    end

  end
end
