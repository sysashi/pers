defmodule Pers.Admin.ProjectControllerTest do
  use Pers.ConnCase
  import Plug.Test

  alias Pers.Project
  @valid_attrs %{desc: "some content", 
                 links: %{}, 
                 name: "some content", 
                 status: "some content"}

  @invalid_attrs %{}

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
    conn = get conn, admin_project_path(conn, :index)
    assert json_response(conn, 200)["data"]
  end

  test "shows chosen resource", %{conn: conn} do
    import Ecto.DateTime, only: [to_iso8601: 1]
    project = Repo.insert! %Project{}
    conn = get conn, admin_project_path(conn, :show, project)
    # FIXME  do something with datetime fields
    assert json_response(conn, 200)["data"] == %{"id" => project.id,
      "name" => project.name,
      "links" => project.links,
      "desc" => project.desc,
      "status" => project.status,
      "published_at" => project.published_at,
      "updated_at" => to_iso8601(project.updated_at),
      "inserted_at" => to_iso8601(project.inserted_at)}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, admin_project_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, admin_project_path(conn, :create), project: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, admin_project_path(conn, :create), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = put conn, admin_project_path(conn, :update, project), project: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = put conn, admin_project_path(conn, :update, project), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    project = Repo.insert! %Project{}
    conn = delete conn, admin_project_path(conn, :delete, project)
    assert response(conn, 204)
    refute Repo.get(Project, project.id)
  end
end
