defmodule Pers.Repo.Migrations.CreateLog do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :body, :string

      timestamps
    end

  end
end
