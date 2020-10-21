defmodule Warehouse.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do

    Memento.Table.create!(Warehouse.Table, disc_copies: [node()])
    children = [
      # Starts a worker by calling: Warehouse.Worker.start_link(arg)
      # {Warehouse.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Warehouse.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
