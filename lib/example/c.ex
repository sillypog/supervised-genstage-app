defmodule Example.C do
  use GenStage

  ##########
  # Client API
  ##########
  def start_link(delay) do
    GenStage.start_link(__MODULE__, delay)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, opts},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end


  ##########
  # Server callbacks
  ##########

  @impl GenStage
  def init(delay) do
    IO.puts "Initialized Consumer C"
    {:consumer, delay, subscribe_to: [{Example.B, min_demand: 0, max_demand: 1}]}
  end

  @impl GenStage
  def handle_events(events, _from, state) do
    :timer.sleep(state)

    IO.write("Consumer C handling events: ")
    IO.inspect(events, charlists: false)

    {:noreply, [], state}
  end
end
