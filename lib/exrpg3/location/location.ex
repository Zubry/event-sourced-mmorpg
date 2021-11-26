defmodule Location do
  def start(id) do
    DynamicSupervisor.start_child(Location.DynamicSupervisor, {Location.Aggregator, id: id})
  end

  def move(id, {x, y}) do
    [{pid, _}] = Registry.lookup(Location.Registry, id)

    {:ok, _events} = Location.Aggregator.move(pid, {x, y})

    :ok
  end

  def teleport(id, {x, y}) do
    [{pid, _}] = Registry.lookup(Location.Registry, id)

    {:ok, _events} = Location.Aggregator.teleport(pid, {x, y})

    :ok
  end
end
