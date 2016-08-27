defmodule Pers.Repo.Migrations.CreateAdmin do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :name, :string
      add :nick, :string
      add :email, :string
      add :pwhash, :string

      timestamps
    end

    create unique_index(:admins, [:name])
  end
end
