defmodule Pers.Page do
  use Pers.Web, :model
  alias Pers.Page

  schema "pages" do
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
    |> validate_required([:link])
    |> unique_constraint(:link)
  end

  # FIXME
  def changeset(page, :publish, params) do
    already_published = !!params["published_at"]
    publish? = !!params["published"]
    cond do
      publish? && already_published -> 
        page
      publish? && !already_published ->
        page
        |> put_change(:published_at, Ecto.DateTime.utc)
      !publish? -> 
        page
        |> put_change(:published_at, nil)
    end
  end 


  def published do
    from(p in Page,
     where: not is_nil(p.published_at))
  end

  def pages_sitemap do
    from(p in published(),
     order_by: p.title,
     select: {p.title, p.updated_at})
  end
end
