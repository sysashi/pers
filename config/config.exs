# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pers,
  ecto_repos: [Pers.Repo]

# Configures the endpoint
config :pers, Pers.Endpoint,
  url: [host: "localhost"],
  static_url: [host: "localhost", path: "/assets"],
  secret_key_base: "fGlvfXb/yOqy4aZxNd8/KrZcpTkcggVmD6gofmF74YiZPXW31+Q1CoQxpgm3bU1z",
  render_errors: [view: Pers.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pers.PubSub,
           pool_size: 1,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
