defmodule Pers.Page do
  use Pers.Web, :model

  schema "pages" do
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
    |> validate_required([:link])
    |> unique_constraint(:link)
  end
end
