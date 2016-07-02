defmodule Pers.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :desc, :text
      add :name, :string

      timestamps
    end

  end
end
