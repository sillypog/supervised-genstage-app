defmodule Example.B do
  use GenStage

  ##########
  # Client API
  ##########
  def start_link(pipeline_name, multiplier, max_demand) do
    process_name = Enum.join([pipeline_name, "B"], "")
    IO.puts "Start Example.B as #{process_name}"
    GenStage.start_link(__MODULE__, [multiplier, max_demand], name: String.to_atom(process_name))
  end


  ##########
  # Server callbacks
  ##########

  def init([multiplier, max_demand]) do
    IO.puts "Initalised Producer/Consumer B with multiplier #{multiplier}"
    # Subscribe to the producer with the max_demand set for this pipeline
    {:producer_consumer, multiplier, subscribe_to: [{Example.A, min_demand: 0, max_demand: max_demand}]}
  end

  def handle_events(events, _from, multiplier) do
    IO.puts "Producer/Consumer B incrementing #{length events} events"
    events = Enum.map(events, & &1 * multiplier)
    {:noreply, events, multiplier}
  end
end
