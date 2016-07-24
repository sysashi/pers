defmodule Pers.SitemapControllerTest do
  use Pers.ConnCase

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, "/sitemap.xml"
    assert conn.status == 200
  end
end
