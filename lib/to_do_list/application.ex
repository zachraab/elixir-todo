defmodule ToDoList.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ToDoListWeb.Telemetry,
      ToDoList.Repo,
      {DNSCluster, query: Application.get_env(:to_do_list, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ToDoList.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ToDoList.Finch},
      # Start a worker by calling: ToDoList.Worker.start_link(arg)
      # {ToDoList.Worker, arg},
      # Start to serve requests, typically the last entry
      ToDoListWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ToDoList.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ToDoListWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
