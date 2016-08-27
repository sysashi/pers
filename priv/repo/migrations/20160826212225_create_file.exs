defmodule Pers.Repo.Migrations.CreateFile do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :name, :string
      add :source, :string, null: false
      add :private, :boolean, [default: true, null: false]
      add :admin_id, references(:admins)

      timestamps()
    end
    
    create index(:files, [:admin_id])
  end
end
