defmodule Pers.ErrorViewTest do
  use Pers.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  setup %{conn: conn} do
    # FIXME
    # setup conn for using default endpoint
    {:ok, conn: get(conn, "/")}
  end

  test "renders 404.html", %{conn: conn} do
    assert render_to_string(Pers.ErrorView, "404.html", [conn: conn]) =~
           "Page not found"
  end

  test "render 500.html", %{conn: conn} do
    assert render_to_string(Pers.ErrorView, "505.html", [conn: conn]) =~
           "Internal server error"
  end

  test "render any other", %{conn: conn} do
    assert render_to_string(Pers.ErrorView, "505.html", [conn: conn]) =~
           "Internal server error"
  end
end
