defmodule Palleto do
  @moduledoc """
  Here we are using a self-assembling pipeline.

  The pipeline stages are no longer being subscribed in a central location.
  Instead, each stage subscribes itself to the preceding stage.

  To make this simple, the producer and producer/consumer are being
  started as named processes.

  What happens if one of the stages crashes?
  """

  use Application

  def start(_type, _args) do
    IO.puts "Application started"

    {:ok, _a} = Example.A.start_link(0)
    {:ok, _b} = Example.B.start_link(2)
    {:ok, _c} = Example.C.start_link

    # We are now having each stage subscribe itself
    # GenStage.sync_subscribe(c, to: b, min_demand: 0, max_demand: 1)
    # GenStage.sync_subscribe(b, to: a, min_demand: 0, max_demand: 1)

    Task.start(fn() -> :timer.sleep(60000) end)
  end
end
