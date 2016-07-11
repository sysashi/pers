defmodule Pers.AdminEndpoint do
  use Phoenix.Endpoint, otp_app: :pers

  plug Pers.Plugs.AdminAssets
end
