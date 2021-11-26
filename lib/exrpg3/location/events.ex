defmodule Location.Events do
  use EventBus.EventSource

  def moved(id: id, from: from, to: to) do
    EventSource.build %{id: make_ref(), topic: :entity_moved} do
      %{id: id, from: from, to: to}
    end
  end
end
