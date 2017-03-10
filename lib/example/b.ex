defmodule Example.B do
  use GenStage

  ##########
  # Client API
  ##########
  def start_link(multiplier) do
    GenStage.start_link(__MODULE__, multiplier)
  end


  ##########
  # Server callbacks
  ##########

  def init(multiplier) do
    IO.puts "Initalised Producer/Consumer B with multiplier #{multiplier}"
    {:producer_consumer, multiplier}
  end

  def handle_events(events, _from, multiplier) do
    IO.puts "Producer/Consumer B incrementing #{length events} events"
    events = Enum.map(events, & &1 * multiplier)
    {:noreply, events, multiplier}
  end
end
