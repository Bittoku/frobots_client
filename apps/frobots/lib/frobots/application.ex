defmodule Frobots.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start a worker by calling: Frobots.Worker.start_link(arg)
      # {Frobots.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Frobots.Supervisor)
  end
end
