use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pers, Pers.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :pers, Pers.Repo,
  adapter: Ecto.Adapters.Postgres,
  System.get_env("DB_USER")
  username: Sytem.get_env("POSTGRES_USER"),
  password: Sytem.get_env("POSTGRES_PASSWORD"),
  database: "pers_test",
  hostname: Sytem.get_env("POSTGRES_HOST"),
  pool: Ecto.Adapters.SQL.Sandbox

config :comeonin, :bcrypt_log_rounds, 4
