import Config

# Do not print debug messages in production
config :logger, level: :info

config :phoenix_client,
  socket: [
    url: "wss://beta.frobots.io/socket/websocket"
  ],
  api: [
    url: "https://beta.frobots.io/api/v1"
  ],
  token: [
    url: "http://beta.frobots.io/token"
  ]
