defmodule Palleto do
  @moduledoc """
  Our pipeline is now being supervised.

  The producer is supervised as a single worker.
  The producer/consumer and consumer are in a separate supervision tree.

  Later, this will allow us to scale the downstream steps of the pipeline
  as an independent unit.

  If a stage dies, a new process is launched and processing continues.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Example.A, [0]),
      supervisor(Example.Supervisor, [])
    ]

    opts = [strategy: :one_for_one, name: ApplicationSupervisor]
    Supervisor.start_link(children, opts)
  end
end
