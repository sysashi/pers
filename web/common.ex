defmodule Pers.Common do
  import Phoenix.Controller, only: [put_layout: 2]

  defmodule AdminLayout do
    def init(opts), do: opts

    def call(conn, _params) do
      put_layout(conn, {Pers.AdminView, "admin_layout.html"})
    end
  end
end
