defmodule ToDoListWeb.PageController do
  use ToDoListWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
