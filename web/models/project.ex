defmodule Pers.Project do
  use Pers.Web, :model

  schema "projects" do
    field :desc, :string
    field :name, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:desc, :name])
    |> validate_required([:desc, :name])
  end
end
