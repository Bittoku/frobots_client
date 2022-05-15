defmodule Frobots.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    socket_opts = Application.get_env(:phoenix_client, :socket)

    children = [
      {ConCache,
       [
         name: :frobots,
         ttl_check_interval: :timer.minutes(1),
         global_ttl: :timer.minutes(10),
         touch_on_read: true
       ]},
      {PhoenixClient.Socket, {socket_opts, name: PhoenixClient.Socket}},
      # todo right now, we just hardcode the channel in which the arena starts in. Will need to make this dynamically allocated once we parallize Arenas (match_id IS Arena ID)
      {Frobots.MatchChannelAdapter, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Frobots.Supervisor)
  end
end
