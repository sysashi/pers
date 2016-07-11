defmodule Pers.Plugs.AdminAssets do
  use Plug.Builder

  plug Plug.Static,
    at: "/assets", 
    from: "priv/static/admin/", 
    gzip: false,
    only: ~w(css js)
 
end
