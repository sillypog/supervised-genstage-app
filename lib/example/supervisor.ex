defmodule Example.Supervisor do
  use Supervisor

  def start_link([name, consumer_delay]) do
    IO.puts "Example.Supervisor #{name} #{consumer_delay}"
    Supervisor.start_link(__MODULE__, [name, consumer_delay])
  end

  @impl Supervisor
  def init([name, consumer_delay]) do
    # Launch the consumer with the delay we received from the application
    children = [
      {Example.B, [2]},
      {Example.C, [consumer_delay]}
    ]

    # Launch the supervisor with the name we received from the application
    opts = [strategy: :one_for_one, name: name]
    Supervisor.init(children, opts)
  end
end
