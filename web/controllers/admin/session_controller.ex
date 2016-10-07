defmodule Pers.Admin.SessionController do
  use Pers.Web, :controller

  def login_page(conn, _params) do
    changeset = if prev_changeset = conn.assigns[:prev_changeset],
      do: prev_changeset, else: Pers.Admin.changeset(%Pers.Admin{})

    error = get_flash(conn, :error)

    if get_session(conn, :login) do
      conn
      |> redirect(to: dashboard_path(conn, :index))
    else
      conn
      |> render("login_form.html", changeset: changeset, error: error)
    end
  end

  def create(conn, %{"admin" => admin_params}) do
    changeset = Pers.Admin.changeset(%Pers.Admin{}, admin_params)
    case try_login(changeset) do
      {true, admin} ->
        conn
        |> put_session(:admin_id, admin.id)
        |> redirect(to: dashboard_path(conn, :index))
      {false, _changeset} ->
        error = %{message: "Login error"}
        conn
        |> put_flash(:error, error)
        |> redirect(to: session_path(conn, :login_page))
    end
  end

  def delete(conn, _params) do
    front_page = Pers.Endpoint.url()
    conn
    |> delete_session(:login)
    |> redirect(external: front_page)
  end

  defp try_login(changeset) do
    if changeset.valid? do
      name = Ecto.Changeset.get_field(changeset, :name)
      password = Ecto.Changeset.get_field(changeset, :password)

      case Pers.Repo.get_by(Pers.Admin, name: name) do
        %Pers.Admin{} = admin ->
          {Comeonin.Bcrypt.checkpw(password, admin.pwhash), admin}
        nil ->
          {Comeonin.Bcrypt.dummy_checkpw(), changeset}
      end
    else
      {false, changeset}
    end
  end
end
