defmodule ToDoListWeb.PageController do
  use ToDoListWeb, :controller
  alias ToDoList.Lists

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home)
  end

  def lists(conn, _params) do
    lists = Lists.list_lists()
    render(conn, :lists, lists: lists)
  end
end
