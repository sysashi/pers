defmodule Pers.Repo.Migrations.AddPublishedAtToNotes do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add :published_at, :datetime
    end

  end
end
