defmodule Palleto do
  @moduledoc """
  What if each pipeline makes different demands on the producer?

  The supervisor has been modified to take demand as a parameter.
  This is set as max_demand on both the producer/consumer and
  consumer.
  """
  use Application

  def start(_type, _args) do
    children = [
      {Example.A, [0]},
      {Example.Supervisor, ["FastPipeline", 1000, 1]},
      {Example.Supervisor, ["SlowPipeline", 5000, 3]}
    ]

    opts = [strategy: :one_for_one, name: ApplicationSupervisor]
    Supervisor.start_link(children, opts)
  end
end
