defmodule Pers.ProjectControllerTest do
  use Pers.ConnCase

  alias Pers.Project
  @valid_attrs %{desc: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, project_path(conn, :index)
    assert conn.status == 200 
  end

  test "shows chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = get conn, project_path(conn, :show, project)
    assert conn.status == 200 
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, project_path(conn, :show, -1)
    end
  end
end
