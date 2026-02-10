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
    children = [
      {Example.A, [0]},
      {Example.Supervisor, ["Pipeline", 1000]}
    ]

    opts = [strategy: :one_for_one, name: ApplicationSupervisor]
    Supervisor.start_link(children, opts)
  end
end
