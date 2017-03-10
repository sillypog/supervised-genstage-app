defmodule Palleto do
  @moduledoc """
  What if each pipeline makes different demands on the producer?

  The supervisor has been modified to take demand as a parameter.
  This is set as max_demand on both the producer/consumer and
  consumer.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Example.A, [0]),
      supervisor(Example.Supervisor, ["FastPipeline", 1000, 1], id: 1),
      supervisor(Example.Supervisor, ["SlowPipeline", 5000, 3], id: 2)
    ]

    opts = [strategy: :one_for_one, name: ApplicationSupervisor]
    Supervisor.start_link(children, opts)
  end
end
