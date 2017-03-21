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

  def init(:ok) do
    IO.puts "Initialized Consumer C"
    # Subscribe to the named producer/consumer process when starting
    {:consumer, :the_state_does_not_matter, subscribe_to: [{Example.B, min_demand: 0, max_demand: 1}]}
  end

  def handle_events(events, _from, state) do
    :timer.sleep(1000)

    IO.inspect(events, char_lists: false)

    {:noreply, [], state}
  end
end
