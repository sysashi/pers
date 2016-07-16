defmodule Pers.Project do
  use Pers.Web, :model
  alias Pers.Project

  schema "projects" do
    field :desc, :string
    field :status, :string
    field :name, :string
    field :links, :map

    field :published_at, Ecto.DateTime
    timestamps
  end

  @req_fields [:desc, :name, :status, :links]
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @req_fields)
    |> validate_required([:desc, :name])
  end

  def count do
    from(p in Project, select: count(p.id))
  end

  def recent(limit) do
    from(p in Project, 
     order_by: [desc: p.published_at],
     limit: ^limit)
  end
end
