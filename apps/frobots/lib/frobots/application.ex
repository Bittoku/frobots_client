defmodule Frobots.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    socket_opts =
      Application.get_env(:phoenix_client, :socket)

    children = [
      {PhoenixClient.Socket, {socket_opts, name: PhoenixClient.Socket}}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Frobots.Supervisor)
  end
end
