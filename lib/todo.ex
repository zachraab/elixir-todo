defmodule Todo do
  use Application
  def start(_type, _args) do
    IO.puts(Todo.hello())
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def hello do
    :world
  end
end
