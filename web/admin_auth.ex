defmodule Pers.AdminAuth do
  import Plug.Conn
  import Phoenix.Controller

  defmodule EnsureAdmin do
    def init(opts), do: opts

    def call(conn, _opts) do
      case get_session(conn, :admin_id) do
        id when is_integer(id)-> 
          admin = Pers.Repo.get!(Pers.Admin, id)
          conn
          |> assign(:current_admin, admin)
        _ -> 
          conn
          |> put_layout(false)
          |> put_status(404)
          |> render(Pers.ErrorView, "404.html")
          |> halt()
      end
    end
  end
end
