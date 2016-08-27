defmodule Pers.Repo.Migrations.AddPublishedAtToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :published_at, :datetime
    end
  end
end
