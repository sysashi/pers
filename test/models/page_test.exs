defmodule Pers.PageTest do
  use Pers.ModelCase

  alias Pers.Page

  @valid_attrs %{link: "somelink"}
  @invalid_attrs %{link: nil}

  test "changeset with valid attributes" do
    changeset = Page.changeset(%Page{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Page.changeset(%Page{}, @invalid_attrs)
    refute changeset.valid?
  end
end
