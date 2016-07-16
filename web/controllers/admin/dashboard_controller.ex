defmodule Pers.Admin.Dashboard do
  use Pers.Web, :controller 

  # TODO decouple unprotected {login, logout, loginform} from
  # dashboard index (protected by plug at admin router)

  def index(conn, _params) do
    conn
    |> put_session(:admin, true)
    |> render("index.html")
  end

  def login_form(conn, _params) do
    changeset = if prev_changeset = conn.assigns[:prev_changeset] do
      prev_changeset
    else
      Pers.Admin.changeset(%Pers.Admin{})
    end

    error = get_flash(conn, :error)
    conn
    |> render("login_form.html", changeset: changeset, error: error)
  end

  def login(conn, %{"admin" => admin_params}) do
    changeset = Pers.Admin.changeset(%Pers.Admin{}, admin_params)
    case try_login(changeset) do
      {true, admin} ->
        conn 
        |> put_session(:login, admin)
        |> redirect(to: dashboard_path(conn, :index))
      {false, _changeset} -> 
        error = %{message: "Login error"}
        conn 
        |> put_flash(:error, error)
        |> redirect(to: dashboard_path(conn, :login_form))
    end
  end

  def logout(conn, _params) do
    front_page = Pers.Endpoint.url() 
    conn
    |> delete_session(:login)
    |> redirect(external: front_page)
  end


  def create_admin(changeset) do
    changeset = Pers.Admin.changeset(changeset) 
    pwhash = Ecto.Changeset.get_field(changeset, :password)
    |> Comeonin.Bcrypt.hashpwsalt()

    changeset 
    |> Ecto.Changeset.put_change(:pwhash, pwhash)
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
