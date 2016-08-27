defmodule Pers.Note do
  use Pers.Web, :model

  schema "notes" do
    field :title, :string
    field :link, :string
    field :html, :string
    field :markdown, :string
    field :published, :boolean, virtual: true
    field :published_at, Ecto.DateTime

    many_to_many :tags, Tag, join_through: "notes_tags"

    timestamps
  end

  @req_fields [:published, :title, :link, :markdown]
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @req_fields)
    |> validate_required([:title])
  end

  def create_changeset(struct, params) do
    struct
    |> publish(params)
    |> handle_markdown()
  end

  def update_changeset(note, params) do
    note
    |> publish(params)
    |> handle_markdown()
  end

  # FIXME
  def publish(note, params) do
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


  def handle_markdown(changeset) do
    html = 
      changeset
      |> get_field(:markdown) 
      |> md_to_html()

    put_change(changeset, :html, html)
  end

  def md_to_html(nil), do: nil
  def md_to_html(md) when is_binary(md) do
    md
    |> Earmark.to_html(%Earmark.Options{gfm: true})
  end

  def count do
    from(n in Note, select: count(n.id))
  end

  def published do
    from(n in Note,
     where: not is_nil(n.published_at),
     order_by: [desc: n.published_at])
  end

  def recent(limit \\ 10) do
    from(n in published(), 
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
