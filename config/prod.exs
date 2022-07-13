import Config

# Do not print debug messages in production
config :logger, level: :info

config :phoenix_client,
  socket: [
    url: "wss://frobots.io/socket/websocket"
  ],
  api: [
    url: "https://frobots.io/api/v1"
  ]
