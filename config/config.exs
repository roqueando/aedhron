# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :table,
  generators: [context_app: false]

# Configures the endpoint
config :table, Table.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MpG0HSM440ZK24qY0z1vfwAhpvKk3gBFh1FUZxhzbn1pZg8OgcKf2eoKtBDAX5EJ",
  render_errors: [view: Table.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Table.PubSub,
  live_view: [signing_salt: "g2mAfQSL"]

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :mnesia,
  dir: '.mnesia/#{Mix.env}/#{node()}'

config :hermes, Hermes.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "smtp.mailtrap.io",
  port: 2525,
  username: "0e136d30bce349", # or {:system, "SMTP_USERNAME"}
  password: "dc3b6897266fc5", # or {:system, "SMTP_PASSWORD"}
  tls: :if_available, # can be `:always` or `:never`
  ssl: false, # can be `true`,
  retries: 1,
  no_mx_lookups: false, # can be `true`
  auth: :if_available 

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
