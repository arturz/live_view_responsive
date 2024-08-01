defmodule LiveViewResponsive.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveViewResponsive.Endpoint
    ]

    opts = [strategy: :one_for_one, name: LiveViewResponsive.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
