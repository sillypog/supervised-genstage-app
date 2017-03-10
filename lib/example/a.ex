defmodule Example.A do
  use GenStage

  ##########
  # Client API
  ##########
  def start_link(counter) do
    GenStage.start_link(__MODULE__, counter)
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
    # If the counter is 3 and we ask for 2 items, we will
    # emit the items 3 and 4, and set the state to 5.
    events = Enum.to_list(counter..counter+demand-1)
    {:noreply, events, counter + demand}
  end
end
