defmodule Example.Supervisor do
  use Supervisor

  def start_link(name, consumer_delay) do
    IO.puts "Example.Supervisor #{name} #{consumer_delay}"
    Supervisor.start_link(__MODULE__, [name, consumer_delay])
  end

  def init([pipeline_name, consumer_delay]) do
    # Pass the pipeline name to the children so they can build
    # their names dynamically to avoid collisions
    children = [
      worker(Example.B, [pipeline_name, 2]),
      worker(Example.C, [pipeline_name, consumer_delay])
    ]

    opts = [strategy: :one_for_one, name: pipeline_name]
    supervise(children, opts)
  end
end
