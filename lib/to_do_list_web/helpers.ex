defmodule ToDoListWeb.Helpers do
  def active_class(conn, path) do
    if conn.request_path == path do
      "border-black border-b-2"
    else
      ""
    end
  end
end
