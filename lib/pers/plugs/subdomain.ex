defmodule Pers.Plugs.Subdomain do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, []) do
    conn
  end

  def call(conn, opts) do
    conn
  end

  defp host do
     %{host: host} = Pers.Endpoint.struct_url
     [host: host]
  end
end
