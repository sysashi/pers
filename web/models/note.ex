defmodule Pers.Note do
  use Pers.Web, :model
  alias Pers.Note

  schema "notes" do
    field :title, :string
    field :link, :string
    field :html, :string
    field :markdown, :string
    field :published_at, Ecto.DateTime

    timestamps
  end

  @req_fields [:title, :link, :html, :markdown]
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @req_fields)
    |> validate_required([])
    |> unique_constraint(:link)
  end

  def count do
    from(n in Note, select: count(n.id))
  end

  def published do
    from(n in Note,
     where: not is_nil(n.published_at))
  end

  def recent(limit) do
    from(n in published(), 
     order_by: [desc: n.published_at],
     limit: ^limit)
  end

  def paged(limit, offset) do
    from(n in recent(limit),
     offset: ^offset)
  end
end
