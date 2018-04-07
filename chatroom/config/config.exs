# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :faster,
  ecto_repos: [Faster.Repo]

# Configures the endpoint
config :faster, Faster.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EiFcDrRHtdMK8PCnMkrE/wkJnGAyWLqIpp0Jr4YSUTo9mu4gqk77yaQEYwPIGqy7",
  render_errors: [view: Faster.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Faster.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :cipher, keyphrase: "testiekeyphraseforcipher",
                ivphrase: "testieivphraseforcipher",
                magic_token: "magictoken"
