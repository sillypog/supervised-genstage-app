defmodule Example.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Example.B, [2]),   # We're still multiplying the input by 2
      worker(Example.C, [1000]) # The delay has been parameterized. Set to 1 second
    ]

    opts = [strategy: :one_for_one, name: Example.Supervisor]
    supervise(children, opts)
  end
end
