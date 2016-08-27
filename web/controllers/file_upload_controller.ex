defmodule Pers.FileUploadController do
  use Pers.Web, :controller
  alias Pers.File

  plug Pers.AdminAuth.EnsureAdmin 

  def upload(conn, %{"file" => file_params}) do
    current_admin = conn.assigns[:current_admin]
    changeset = 
      Ecto.build_assoc(current_admin, :files)
      |> File.changeset(file_params)

    case Repo.insert(changeset) do
      {:ok, file} ->
        conn
        |> json(%{file: file.name}) # FIXME
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Pers.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
