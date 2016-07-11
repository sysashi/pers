defmodule Pers.Admin do
  use Pers.Web, :model

  schema "admins" do
    field :name, :string
    field :pwhash, :string
    field :password, :string, virtual: true

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :password])
    |> validate_required([:name, :password])
    |> validate_length(:password, min: 6)
    |> validate_length(:name, min: 3)
    |> unique_constraint(:name)
  end
end
