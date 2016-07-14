defmodule Pers.Admin.PageController do
  use Pers.Web, :controller

  alias Pers.Page

  def index(conn, _params) do
    pages = Repo.all(Page)
    render(conn, "index.json", pages: pages)
  end

  def create(conn, %{"page" => page_params}) do
    changeset = Page.changeset(%Page{}, page_params)

    case Repo.insert(changeset) do
      {:ok, page} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", page_path(conn, :show, page))
        |> render("show.json", page: page)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Pers.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    page = Repo.get!(Page, id)
    render(conn, "show.json", page: page)
  end

  def update(conn, %{"id" => id, "page" => page_params}) do
    page = Repo.get!(Page, id)
    changeset = page
    |> Page.changeset(page_params)
    |> Page.changeset(:publish, page_params)

    case Repo.update(changeset) do
      {:ok, page} ->
        render(conn, "show.json", page: page)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Pers.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    page = Repo.get!(Page, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(page)

    send_resp(conn, :no_content, "")
  end
end
