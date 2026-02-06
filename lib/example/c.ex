defmodule Example.C do
  use GenStage

  ##########
  # Client API
  ##########
  def start_link do
    GenStage.start_link(__MODULE__, :ok)
  end


  ##########
  # Server callbacks
  ##########

  @impl GenStage
  def init(:ok) do
    IO.puts "Initialized Consumer C"
    {:consumer, :the_state_does_not_matter}
  end

  @impl GenStage
  def handle_events(events, _from, state) do
    # Slow things down so we can follow the output
    :timer.sleep(1000)

    IO.write("Consumer C handling events: ")
    IO.inspect(events, charlists: false)

    # Consumers don't emit events
    {:noreply, [], state}
  end
end
