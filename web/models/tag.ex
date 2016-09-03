defmodule Pers.Tag do
  use Pers.Web, :model

  schema "tags" do
    field :content, :string

    many_to_many :notes, Note, join_through: "notes_tags"
    many_to_many :files, File, join_through: "files_tags"
    many_to_many :projects, Project, join_through: "projects_tags"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
  end
end
