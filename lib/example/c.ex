defmodule Example.C do
  use GenStage

  ##########
  # Client API
  ##########
  def start_link(pipeline_name, delay, max_demand) do
    process_name = Enum.join([pipeline_name, "C"], "")
    IO.puts "Start Example.B as #{process_name}"
    GenStage.start_link(__MODULE__, [pipeline_name, delay, max_demand], name: String.to_atom(process_name))
  end


  ##########
  # Server callbacks
  ##########

  def init([pipeline_name, delay, max_demand]) do
    producer = Enum.join([pipeline_name, "B"], "")
    IO.puts "Subscribing Consumer C to #{producer}"
    # Subscribe to producer/consumer with the max_demand set for this pipeline
    {:consumer, [pipeline_name, delay], subscribe_to: [{String.to_atom(producer), min_demand: 0, max_demand: max_demand}]}
  end

  def handle_events(events, _from, [pipeline_name, counter]) do
    :timer.sleep(counter)

    event_string = Enum.join(events, ", ")
    IO.puts "#{pipeline_name}: #{event_string}"

    {:noreply, [], [pipeline_name, counter]}
  end
end
