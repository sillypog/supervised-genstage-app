defmodule Palleto do
  @moduledoc """
  Now that the pipeline is supervised, how can it be manipulated?

  Here we are passing arguments to the supervisor and workers
  from the application.

  The name of the supervisor process is being passed as the first argument.
  The delay for the consumer process is being passed as the second argument,
  and will be passed from the supervisor to the consumer.

  What if we try to bring up a second consumer supervisor?
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Example.A, [0]),
      supervisor(Example.Supervisor, ["Pipeline", 100], id: 1)
    ]

    opts = [strategy: :one_for_one, name: ApplicationSupervisor]
    Supervisor.start_link(children, opts)
  end
end
