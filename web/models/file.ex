defmodule Pers.File do
  use Arc.Ecto.Schema
  use Pers.Web, :model

  schema "files" do
    field :name, :string
    field :source, Pers.StaticFile.Type
    field :private, :boolean, default: true

    belongs_to :admin, Admin
    many_to_many :tags, Tag, join_through: "files_tags"

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :admin_id])
    |> assoc_constraint(:admin)
    |> validate_required([:name])
    |> cast_attachments(params, [:source])
  end
end
