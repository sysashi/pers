defmodule Pers.Note do
  use Pers.Web, :model
  alias Pers.Note

  schema "notes" do
    field :title, :string
    field :link, :string
    field :html, :string
    field :markdown, :string

    field :published, :boolean, virtual: true
    field :published_at, Ecto.DateTime

    timestamps
  end

  @req_fields [:published, :title, :link, :html, :markdown]
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @req_fields)
    |> validate_required([:title])
    # |> unique_constraint(:link)
  end

  # FIXME
  def changeset(note, :publish, params) do
    already_published = !!params["published_at"]
    publish? = !!params["published"]
    cond do
      publish? && already_published -> 
        note
      publish? && !already_published ->
        note
        |> put_change(:published_at, Ecto.DateTime.utc)
      !publish? -> 
        note
        |> put_change(:published_at, nil)
    end
  end 

  def count do
    from(n in Note, select: count(n.id))
  end

  def published do
    from(n in Note,
     where: not is_nil(n.published_at))
  end

  def count_published do
    from(n in published(),
     select: count(n.id))
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

  def notes_sitemap do
    from(n in published(),
     order_by: n.title,
     select: {n.id, n.updated_at})
  end
end
