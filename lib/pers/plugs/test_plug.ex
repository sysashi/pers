defmodule Stats do

  defmodule Plug do
    import Elixir.Plug.Conn
    require Logger

    def init(opts), do: opts

    def call(conn, opts) do
      # measure request time
      conn = assign(conn, :start_time, now())

      register_before_send(conn, fn conn -> 
        diff = now() - conn.assigns[:start_time]
        Logger.info("Response time: #{diff}ms") 
        conn
      end)  
    end

    defp now do
      :erlang.monotonic_time(:milli_seconds)
    end
  end
end
