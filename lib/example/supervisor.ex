defmodule Example.Supervisor do
  use Supervisor

  def start_link(name, consumer_delay, demand) do
    IO.puts "Example.Supervisor #{name} #{consumer_delay}"
    Supervisor.start_link(__MODULE__, [name, consumer_delay, demand], name: String.to_atom(name))
  end

  def child_spec([name | _] = opts) do
    %{
      id: name,
      start: {__MODULE__, :start_link, opts},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }
  end

  @impl Supervisor
  def init([pipeline_name, consumer_delay, demand]) do
    children = [
      {Example.B, [pipeline_name, 2, demand]},
      {Example.C, [pipeline_name, consumer_delay, demand]}
    ]

    opts = [strategy: :one_for_one, name: pipeline_name]
    Supervisor.init(children, opts)
  end
end
