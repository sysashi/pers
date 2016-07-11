defmodule Pers.Plugs.PublicAssets do
  use Plug.Builder

  plug Plug.Static,
    at: "/assets", 
    from: :pers, 
    gzip: false,
    only: ~w(css js)
 
end
