defmodule Pers.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :desc, :text
      add :name, :string
      add :status, :string
      add :published_at, :datetime
      add :metadata, :map

      timestamps
    end

  end
end
