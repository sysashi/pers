defmodule Pers.Page do
  use Pers.Web, :model
  use Pers.ModelHelpers, :publish

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

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @req_fields)
    |> validate_required([:link])
    |> unique_constraint(:link)
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
