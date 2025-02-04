defmodule ToDoListWeb.NotFoundLive do
  use ToDoListWeb, :live_view

  def mount(_params, _session, _socket) do
    raise ToDoListWeb.NotFoundError
  end
end
