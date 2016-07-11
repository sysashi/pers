defmodule Pers.Repo.Migrations.AddRemoveNoteFields do
  use Ecto.Migration

  def up do
    alter table(:notes) do
      remove :body

      add :html, :text
      add :markdown, :text
      add :link, :string
    end
  end

  def down do
    alter table(:notes) do
      add :body, :text

      remove :html
      remove :markdown
      remove :link
    end
  end
end
