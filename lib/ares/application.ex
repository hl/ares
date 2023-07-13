defmodule Ares.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    cub_db_config = Application.get_env(:ares, CubDB)

    children = [
      {CubDB, cub_db_config}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ares.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
