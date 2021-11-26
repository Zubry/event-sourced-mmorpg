defmodule Location.Aggregator do
  use GenServer

  defstruct id: nil, x: nil, y: nil

  def start_link(id: id) do
    GenServer.start_link(__MODULE__, id)
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
    events = [{:entity_moved, id: state.id, from: {state.x, state.y}, to: {new_state.x, new_state.y}}]

    {:reply, events, new_state}
  end

  def handle_call({:teleport, {x, y}}, _from, %__MODULE__{} = state) do
    new_state = %__MODULE__{ state | x: x, y: y }
    events = [{:entity_moved, id: state.id, from: {state.x, state.y}, to: {new_state.x, new_state.y}}]

    {:reply, events, new_state}
  end
end