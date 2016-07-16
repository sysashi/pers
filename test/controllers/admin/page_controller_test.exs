defmodule Pers.Admin.PageControllerTest do
  use Pers.ConnCase
  import Plug.Test
  alias Pers.Page

  @valid_attrs %{html: "some content", link: "some", markdown: "some content", title: "some content"}
  @invalid_attrs %{link: ""}

  setup %{conn: conn} do
    admin = %Pers.Admin{} 
    |> Pers.Admin.changeset(%{name: "testme", password: "testme"})
    |> Pers.Admin.Dashboard.create_admin()

    Repo.insert(admin)

    auth = post(conn, dashboard_path(conn, :login), admin: [name: "testme", password: "testme"])
    conn = recycle_cookies(conn, auth)
    |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end


  test "lists all entries on index", %{conn: conn} do
    conn = get conn, admin_page_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    page = Repo.insert! %Page{}

    conn = get conn, admin_page_path(conn, :show, page)

    resp = json_response(conn, 200)["data"] |> Map.keys
    attrs = @valid_attrs |> Map.keys() |> Enum.map(&(to_string(&1)))

    assert Enum.all? attrs, fn f -> f in resp end
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, admin_page_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, admin_page_path(conn, :create), page: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Page, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, admin_page_path(conn, :create), page: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    page = Repo.insert! %Page{}
    conn = put conn, admin_page_path(conn, :update, page), page: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Page, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    page = Repo.insert! %Page{}
    conn = put conn, admin_page_path(conn, :update, page), page: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    page = Repo.insert! %Page{}
    conn = delete conn, admin_page_path(conn, :delete, page)
    assert response(conn, 204)
    refute Repo.get(Page, page.id)
  end
end
