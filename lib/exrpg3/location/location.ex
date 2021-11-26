defmodule Location do
  def move(id, {x, y}) do
    {:ok, _events} = Location.Aggregator.move(id, {x, y})

    :ok
  end

  def teleport(id, {x, y}) do
    {:ok, _events} = Location.Aggregator.teleport(id, {x, y})

    :ok
  end
end
