defmodule Pers.Repo.Migrations.AddProjectsTagsTable do
  use Ecto.Migration

  def change do
    create table(:projects_tags, primary_key: false) do
      add :project_id, references(:projects)
      add :tag_id, references(:tags)
    end

    create index(:projects_tags, [:project_id, :tag_id], unique: true)
  end
end
