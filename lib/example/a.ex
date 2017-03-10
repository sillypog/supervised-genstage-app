defmodule Example.A do
  use GenStage

  ##########
  # Client API
  ##########
  def start_link(counter) do
    GenStage.start_link(__MODULE__, counter, name: __MODULE__)
  end


  ##########
  # Server callbacks
  ##########

  def init(counter) do
    IO.puts "Initalised Producer A with counter at #{counter}"
    {:producer, counter}
  end

  def handle_demand(demand, counter) when demand > 0 do
    IO.puts "Producer A handling demand of #{demand} with #{counter}"
    events = Enum.to_list(counter..counter+demand-1)
    {:noreply, events, counter + demand}
  end
end
