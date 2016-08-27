defmodule Pers.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :content, :string, null: false

      timestamps()
    end

    create index(:tags, [:content], unique: true)
  end
end
