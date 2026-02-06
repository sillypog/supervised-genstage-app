defmodule Example.Supervisor do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @impl Supervisor
  def init(:ok) do
    children = [
      {Example.B, [2]},   # We're still multiplying the input by 2
      {Example.C, [1000]} # The delay has been parameterized. Set to 1 second
    ]

    opts = [strategy: :one_for_one, name: Example.Supervisor]
    Supervisor.init(children, opts)
  end
end
