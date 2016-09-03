defmodule Pers.Project do
  use Pers.Web, :model

  schema "projects" do
    field :desc, :string
    field :status, :string
    field :name, :string
    field :published_at, Ecto.DateTime
    embeds_one :metadata, Pers.Project.Metadata

    many_to_many :tags, Tag, join_through: "projects_tags"

    timestamps
  end

  @req_fields [:desc, :name, :status]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @req_fields)
    |> cast_embed(:metadata)
    |> validate_required([:desc, :name])
  end

  def recent(limit) do
    from(p in Project,
     order_by: [desc: p.published_at],
     limit: ^limit)
  end

  def projects_sitemap do
    from(p in Project,
     order_by: p.name,
     select: {p.name, p.updated_at})
  end

  def count do
    from(p in Project, select: count(p.id))
  end
end

defmodule Pers.Project.Metadata do
  use Pers.Web, :model

  embedded_schema do
    embeds_many :links, Pers.Project.Link
    field :color, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:color])
    |> cast_embed(:links)
  end
end

defmodule Pers.Project.Link do
  use Pers.Web, :model

  embedded_schema do
    field :path, :string
    field :showas, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:path])
    |> validate_required([:path])
  end
end

