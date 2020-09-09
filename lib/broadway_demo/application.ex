defmodule BroadwayDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # {BroadwayDemo.Processor, []},
      {BroadwayDemo.ProcessorWithBatcher, []}
      # Starts a worker by calling: BroadwayDemo.Worker.start_link(arg)
      # {BroadwayDemo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BroadwayDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
