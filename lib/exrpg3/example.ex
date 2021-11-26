defmodule Example.Producer do
  @moduledoc false
  use GenStage

  def process(event_shadow) do
    push(event_shadow)
  end

  def start_link(_) do
    EventBus.subscribe({__MODULE__, [".*"]})

    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    {:producer, []}
  end

  def push(event_shadow) do
    GenServer.cast(__MODULE__, {:push, event_shadow})
  end

  def handle_cast({:push, event_shadow}, state) do
    {:noreply, [event_shadow], state}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end

defmodule Example.Consumer do
  @moduledoc false

  use GenStage
  require Logger

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [{Example.Producer, min_demand: 0, max_demand: 1}]}
  end

  def handle_events([{topic, id}], _from, state) do
    {topic, id}
    |> EventBus.fetch_event()
    |> inspect()
    |> Logger.info()

    EventBus.mark_as_completed({__MODULE__, {topic, id}})

    {:noreply, [], state}
  end
end
