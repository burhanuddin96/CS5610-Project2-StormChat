use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :board, Board.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :board, Board.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "board_test",
  pool: Ecto.Adapters.SQL.Sandbox

# Fast and insecure password hashing
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1
