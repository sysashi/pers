defmodule Pers.Admin.NoteControllerTest do
  use Pers.ConnCase
  import Plug.Test
  alias Pers.Note


  @valid_attrs %{link: "test-link", markdown: "## some content", title: " Test title"}

  @invalid_attrs %{}

  setup_all  do
    :ok
  end

  setup %{conn: conn} do
    admin = %Pers.Admin{} 
    |> Pers.Admin.changeset(%{name: "testme", password: "testme"})
    |> Pers.Admin.create()

    Repo.insert(admin)

    auth = post(conn, session_path(conn, :create), admin: [name: "testme", password: "testme"])
    conn = recycle_cookies(conn, auth)
    |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, admin_note_path(conn, :index)
    assert conn.status == 200
  end

  test "shows chosen resource", %{conn: conn} do
    note = Repo.insert! %Note{}
    conn = get conn, admin_note_path(conn, :show, note)
    resp = json_response(conn, 200)["data"] |> Map.keys
    attrs = @valid_attrs |> Map.keys() |> Enum.map(&(to_string(&1)))

    assert Enum.all? attrs, fn f -> f in resp end

    # assert json_response(conn, 200)["data"] == %{"id" => note.id,
    #   "title" => note.title,
    #   "link" => note.link,
    #   "html" => note.html,
    #   "markdown" => note.markdown}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, admin_note_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, admin_note_path(conn, :create), note: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Note, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, admin_note_path(conn, :create), note: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    note = Repo.insert! %Note{}
    conn = put conn, admin_note_path(conn, :update, note), note: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Note, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    note = Repo.insert! %Note{}
    conn = put conn, admin_note_path(conn, :update, note), note: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    note = Repo.insert! %Note{}
    conn = delete conn, admin_note_path(conn, :delete, note)
    assert response(conn, 204)
    refute Repo.get(Note, note.id)
  end
end
