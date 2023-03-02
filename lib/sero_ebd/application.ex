defmodule SeroEbd.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias SeroEbd.ModbusSim

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: SeroEbd.Worker.start_link(arg)
      # {SeroEbd.Worker, arg}
      {ModbusSim, [id: "1"]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SeroEbd.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
