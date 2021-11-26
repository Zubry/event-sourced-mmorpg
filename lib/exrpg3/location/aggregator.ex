defmodule Location.Aggregator do
  use GenServer

  defstruct id: nil, x: 0, y: 0

  def start_link(id: id) do
    GenServer.start_link(__MODULE__, id, name: {:via, Registry, {Location.Registry, id}})
  end

  def init(id) do
    {:ok, %__MODULE__{ id: id }}
  end

  def move(pid, {dx, dy}) do
    GenServer.call(pid, {:move, {dx, dy}})
  end

  def teleport(pid, {x, y}) do
    GenServer.call(pid, {:teleport, {x, y}})
  end

  def handle_call({:move, {dx, dy}}, _from, %__MODULE__{} = state) do
    new_state = %__MODULE__{ state | x: state.x + dx, y: state.y + dy }
    events = [
      Location.Events.moved(id: state.id, from: {state.x, state.y}, to: {new_state.x, new_state.y})
    ]

    {:reply, {:ok, events}, new_state}
  end

  def handle_call({:teleport, {x, y}}, _from, %__MODULE__{} = state) do
    new_state = %__MODULE__{ state | x: x, y: y }
    events = [
      Location.Events.moved(id: state.id, from: {state.x, state.y}, to: {new_state.x, new_state.y})
    ]

    {:reply, {:ok, events}, new_state}
  end
end
