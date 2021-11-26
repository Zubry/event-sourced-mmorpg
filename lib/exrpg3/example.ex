EventBus.subscribe({Example, [".*"]})

# then in your data store save the event
defmodule Example do
  def process({topic, id} = event_shadow) do
    event = EventBus.fetch_event({topic, id})
    # write your logic to save event_data to a persistent store
    IO.inspect(event)
    EventBus.mark_as_completed({__MODULE__, {topic, id}})
    :ok
  end
end
