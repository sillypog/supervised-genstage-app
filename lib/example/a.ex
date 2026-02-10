defmodule Example.A do
  use GenStage

  ##########
  # Client API
  ##########
  def start_link(counter) do
    GenStage.start_link(__MODULE__, counter, name: __MODULE__)
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
  def init(counter) do
    IO.puts "Initalised Producer A with counter at #{counter}"
    {:producer, counter}
  end

  @impl GenStage
  def handle_demand(demand, counter) when demand > 0 do
    IO.puts "Producer A handling demand of #{demand} with #{counter}"
    events = Enum.to_list(counter..counter+demand-1)
    {:noreply, events, counter + demand}
  end
end
