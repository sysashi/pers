defmodule Pers.Page do
  use Pers.Web, :model

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
  def changeset(page, :publish, params) do
    IO.inspect params
    time = if params["published"] do 
      Ecto.DateTime.utc
    else 
      nil 
    end

    page
    |> cast(params, [:published])
    |> put_change(:published_at, time)
  end 

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @req_fields)
    |> validate_required([:link])
    |> unique_constraint(:link)
  end
end
