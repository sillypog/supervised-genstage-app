defmodule Palleto do
  @moduledoc """
  Here we have a simple pipeline of 3 stages:

  Producer -----> Producer/Consumer -----> Consumer
  Example.A ----> Example.B -------------> Example.C

  Example.A: Generates a number
  Example.B: Modifies the number
  Example.C: Displays the number

  The consumer requests new events one at a time.
  What happens if we change the demand?
  """

  use Application

  def start(_type, _args) do
    IO.puts "Application started"

    {:ok, a} = Example.A.start_link(0)  # Generate numbers starting from 0
    {:ok, b} = Example.B.start_link(2)  # Multiply those numbers by 2
    {:ok, c} = Example.C.start_link

    GenStage.sync_subscribe(c, to: b, min_demand: 0, max_demand: 1)
    GenStage.sync_subscribe(b, to: a, min_demand: 0, max_demand: 1)

    # The pipeline is running in other processes and is working while
    # the application runs

    # Ensure application doesn't immediately exit
    Task.start(fn() -> :timer.sleep(60000) end)
  end
end
