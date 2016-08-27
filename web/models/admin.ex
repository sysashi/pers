defmodule Pers.Admin do
  use Pers.Web, :model
  alias Ecto.Changeset

  schema "admins" do
    field :name, :string
    # TODO
    # field :login_name, :string
    # field :nick_name, :string 
    # field :email, :string
    field :pwhash, :string
    field :password, :string, virtual: true

    has_many :files, Pers.File

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

  def create(changeset) do
    changeset
    |> hash_password()
  end

  def hash_password(%Changeset{changes: %{password: password}} = c) do
      put_change(c, :pwhash, Comeonin.Bcrypt.hashpwsalt(password)) 
  end
end
