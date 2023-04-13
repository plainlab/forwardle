defmodule Forwardle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    maybe_run_migrations()

    children = [
      # Start the Telemetry supervisor
      ForwardleWeb.Telemetry,
      # Start the Ecto repository
      Forwardle.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Forwardle.PubSub},
      # Start Finch
      {Finch, name: Forwardle.Finch},
      # Start the Endpoint (http/https)
      ForwardleWeb.Endpoint
      # Start a worker by calling: Forwardle.Worker.start_link(arg)
      # {Forwardle.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Forwardle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ForwardleWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp maybe_run_migrations() do
    unless Application.get_env(:forwardle, :skip_migrations) do
      Forwardle.ReleaseTasks.init()
    end
  end
end
