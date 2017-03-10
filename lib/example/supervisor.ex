defmodule Example.Supervisor do
  use Supervisor

  def start_link(name, consumer_delay, demand) do
    IO.puts "Example.Supervisor #{name} #{consumer_delay}"
    Supervisor.start_link(__MODULE__, [name, consumer_delay, demand], name: String.to_atom(name))
  end

  def init([pipeline_name, consumer_delay, demand]) do
    children = [
      worker(Example.B, [pipeline_name, 2, demand]),
      worker(Example.C, [pipeline_name, consumer_delay, demand])
    ]

    opts = [strategy: :one_for_one, name: pipeline_name]
    supervise(children, opts)
  end
end
