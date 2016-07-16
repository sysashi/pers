defmodule Pers.PageControllerTest do
  use Pers.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "website"
  end
end
