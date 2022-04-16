defmodule Frobots.ClientAdapter do
  @moduledoc false
  use GenServer
  alias PhoenixClient.{Socket, Channel, Message}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  defp wait_for_socket(socket) do
    unless Socket.connected?(socket) do
      wait_for_socket(socket)
    end
  end

  def start(server, frobots) do
    GenServer.call(server, {:start_frobots, frobots})
  end

  defp nested_list_to_tuple(list) when is_list(list) do
    List.to_tuple(Enum.map(list, &nested_list_to_tuple/1))
  end

  defp nested_list_to_tuple(elem), do: elem

  defp decode_event(msg) do
    # msgs are in a map of shape %{"event" => evt, "args" => args}
    List.to_tuple(
      [String.to_atom(Map.get(msg, "event"))] ++
        Tuple.to_list(nested_list_to_tuple(Map.get(msg, "args")))
    )
  end

  @impl true
  def init(opts) do
    id = Keyword.fetch!(opts, :match_id)
    socket_opts = Application.get_env(:phoenix_client, :socket)
    {:ok, socket} = Socket.start_link(socket_opts)
    wait_for_socket(socket)

    {:ok, _response, channel} =
      Channel.join(socket, "arena:" <> Integer.to_string(id))

    {:ok,
     %{
       socket: socket,
       channel: channel,
       match_id: id
     }}
  end

  @impl true
  def handle_call({:start_frobots, frobots}, _from, state) do
    {:ok, frobots_map} = Channel.push(state.channel, "start_match", frobots)

    gui_pid = :global.whereis_name(Application.get_env(:frobots, :display_process_name))

    state =
      state
      |> Map.put(:frobots_map, frobots_map)
      |> Map.put(:gui_pid, gui_pid)

    {:reply, {:ok, frobots_map}, state}
  end

  @impl true
  def handle_info(%Message{event: "arena_event", payload: payload}, state) do
    IO.puts("Incoming Message: #{inspect(payload)}")
    send(state.gui_pid, decode_event(payload))
    {:noreply, state}
  end

  @impl true
  def handle_info(%Message{event: "phx_error", topic: topic}, state) do
    IO.puts("Error from server: " <> topic)
    {:noreply, state}
  end

  @impl true
  def handle_info(msg, state) do
    IO.puts("Got a message")
    inspect(msg)
    {:noreply, state}
  end
end
