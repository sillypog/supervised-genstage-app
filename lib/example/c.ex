defmodule Example.C do
  use GenStage

  ##########
  # Client API
  ##########
  def start_link(delay) do
    GenStage.start_link(__MODULE__, delay)
  end


  ##########
  # Server callbacks
  ##########

  def init(delay) do
    IO.puts "Initialized Consumer C"
    {:consumer, delay, subscribe_to: [{Example.B, min_demand: 0, max_demand: 1}]}
  end

  def handle_events(events, _from, state) do
    :timer.sleep(state)

    IO.inspect(events, char_lists: false)

    {:noreply, [], state}
  end
end
