defmodule Location do
  def start(id) do
    DynamicSupervisor.start_child(Location.DynamicSupervisor, {Location.Aggregator, id: id})
  end

  def move(id, {x, y}) do
    [{pid, _}] = Registry.lookup(Location.Registry, id)

    {:ok, events} = Location.Aggregator.move(pid, {x, y})

    for event <- events do
      EventBus.notify(event)
    end

    :ok
  end

  def teleport(id, {x, y}) do
    [{pid, _}] = Registry.lookup(Location.Registry, id)

    {:ok, events} = Location.Aggregator.teleport(pid, {x, y})

    for event <- events do
      EventBus.notify(event)
    end

    :ok
  end
end
