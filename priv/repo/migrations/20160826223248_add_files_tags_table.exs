defmodule Pers.Repo.Migrations.AddFilesTagsTable do
  use Ecto.Migration

  def change do
    create table(:files_tags, primary_key: false) do
      add :file_id, references(:files)
      add :tag_id, references(:tags)
    end

    create index(:files_tags, [:file_id, :tag_id], unique: true)
  end
end
