defmodule Zuri.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ZuriWeb.Telemetry,
      # Start the Ecto repository
      Zuri.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Zuri.PubSub},
      # Start Finch
      {Finch, name: Zuri.Finch},
      # Start the Endpoint (http/https)
      ZuriWeb.Endpoint
      # Start a worker by calling: Zuri.Worker.start_link(arg)
      # {Zuri.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Zuri.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ZuriWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
