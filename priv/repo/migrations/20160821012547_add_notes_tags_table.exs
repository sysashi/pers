defmodule Pers.Repo.Migrations.AddNotesTagsTable do
  use Ecto.Migration

  def change do
    create table(:notes_tags, primary_key: false) do
      add :note_id, references(:notes)
      add :tag_id, references(:tags)
    end

    create index(:notes_tags, [:note_id, :tag_id], unique: true)
  end
end
