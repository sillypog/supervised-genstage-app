defmodule Palleto do
  @moduledoc """
  Now that we have named and configurable pipelines, we can start
  multiple producer/consumer and consumer units to read from
  our producer at different rates.

  For this to work, we need to ensure that the producer/consumers
  in each pipeline are launched with different names. Those names
  still need to be discoverable by the consumer in that pipeline.

  To do that, the pipeline name is passed to the supervisors and
  used to construct a modified name for each process, using the
  name of the pipeline and the module.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Example.A, [0]),
      supervisor(Example.Supervisor, ["FastPipeline", 1000], id: 1),
      supervisor(Example.Supervisor, ["SlowPipeline", 5000], id: 2)
    ]

    opts = [strategy: :one_for_one, name: ApplicationSupervisor]
    Supervisor.start_link(children, opts)
  end
end
