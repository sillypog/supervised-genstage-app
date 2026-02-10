defmodule Example.Supervisor do
  use Supervisor

  def start_link(name, consumer_delay) do
    IO.puts "Example.Supervisor #{name} #{consumer_delay}"
    Supervisor.start_link(__MODULE__, [name, consumer_delay])
  end

  def child_spec([name, _] = opts) do
    %{
      id: name,
      start: {__MODULE__, :start_link, opts},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }
  end

  @impl Supervisor
  def init([pipeline_name, consumer_delay]) do
    # Pass the pipeline name to the children so they can build
    # their names dynamically to avoid collisions
    children = [
      {Example.B, [pipeline_name, 2]},
      {Example.C, [pipeline_name, consumer_delay]}
    ]

    opts = [strategy: :one_for_one, name: pipeline_name]
    Supervisor.init(children, opts)
  end
end
