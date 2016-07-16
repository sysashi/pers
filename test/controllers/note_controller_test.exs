defmodule Pers.NoteControllerTest do
  use Pers.ConnCase

  alias Pers.Note
  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, note_path(conn, :index)
    assert conn.status == 200
  end

  test "shows chosen resource", %{conn: conn} do
    note = Repo.insert! %Note{}
    conn = get conn, note_path(conn, :show, note)
    assert conn.status == 200
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, note_path(conn, :show, -1)
    end
  end
end

