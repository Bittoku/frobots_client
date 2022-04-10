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

config :frobots_web,
  generators: [context_app: :frobots]

# Configures the endpoint
config :frobots_web, FrobotsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: FrobotsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Frobots.PubSub,
  live_view: [signing_salt: "iauRoAMU"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/frobots_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure the main viewport for the Scenic application
config :frobots_scenic, :viewport, %{
  name: :main_viewport,
  size: {1000, 1000},
  default_scene: {FrobotsScenic.Scene.Start, nil},
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      name: :glfw,
      opts: [resizeable: false, title: "frobots_scenic"]
    }
  ]
}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
