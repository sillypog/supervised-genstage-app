defmodule Example.B do
  use GenStage

  ##########
  # Client API
  ##########
  def start_link(multiplier) do
    GenStage.start_link(__MODULE__, multiplier, name: __MODULE__)
  end


  ##########
  # Server callbacks
  ##########

  def init(multiplier) do
    IO.puts "Initalised Producer/Consumer B with multiplier #{multiplier}"
    {:producer_consumer, multiplier, subscribe_to: [{Example.A, min_demand: 0, max_demand: 1}]}
  end

  def handle_events(events, _from, multiplier) do
    IO.puts "Producer/Consumer B incrementing #{length events} events"
    events = Enum.map(events, & &1 * multiplier)
    {:noreply, events, multiplier}
  end
end
