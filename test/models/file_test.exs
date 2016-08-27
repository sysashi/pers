defmodule Pers.FileTest do
  use Pers.ModelCase

  alias Pers.File

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = File.changeset(%File{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = File.changeset(%File{}, @invalid_attrs)
    refute changeset.valid?
  end
end
