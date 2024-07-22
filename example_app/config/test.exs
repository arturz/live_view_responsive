import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :example_app, ExampleAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "nz11cARZHThIJYfcB2c0btc/yXloegtxc+XdeeP6C/lciNzTWwbpag6z6Hs9ejoo",
  server: false

# In test we don't send emails.
config :example_app, ExampleApp.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true
