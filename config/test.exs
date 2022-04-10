import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :frobots_web, FrobotsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "4Gc1fIPNYu6rKJcIM6pdpB4GdyUrG6q7CSmxz8Yvd+y1i4YY1FT3CZC44uEGQfz6",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
