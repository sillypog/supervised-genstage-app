defmodule Example.C do
  use GenStage

  ##########
  # Client API
  ##########
  def start_link(pipeline_name, delay) do
    # Build the process name from the pipeline and module names
    process_name = Enum.join([pipeline_name, "C"], "")
    IO.puts "Start Example.B as #{process_name}"
    # Launch the process with the dynamically generated name
    GenStage.start_link(__MODULE__, [pipeline_name, delay], name: String.to_atom(process_name))
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
  def init([pipeline_name, delay]) do
    # The producer consumer was also launched with a dynamically
    # generated name, so we'll need to determine this in order
    # to subscribe
    producer = Enum.join([pipeline_name, "B"], "")
    IO.puts "Subscribing Consumer C to #{producer}"
    {:consumer, [pipeline_name, delay], subscribe_to: [{String.to_atom(producer), min_demand: 0, max_demand: 1}]}
  end

  @impl GenStage
  def handle_events(events, _from, [pipeline_name, counter]) do
    :timer.sleep(counter)

    event_string = Enum.join(events, ", ")
    IO.puts "#{pipeline_name}: Consumer C handling events: #{event_string}"

    {:noreply, [], [pipeline_name, counter]}
  end
end
