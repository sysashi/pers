defmodule Pers.Log do
  use Pers.Web, :model
  alias Pers.Log

  schema "logs" do
    field :body, :string

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body])
    |> validate_required([:body])
  end

  def count do
    from(l in Log, select: count(l.id))
  end

  def recent(limit) do
    from(l in Log,
     order_by: [desc: l.inserted_at],
     limit: ^limit)
  end
end
