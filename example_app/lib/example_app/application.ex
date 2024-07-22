defmodule ExampleApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExampleAppWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:example_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ExampleApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ExampleApp.Finch},
      # Start a worker by calling: ExampleApp.Worker.start_link(arg)
      # {ExampleApp.Worker, arg},
      # Start to serve requests, typically the last entry
      ExampleAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExampleApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExampleAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
