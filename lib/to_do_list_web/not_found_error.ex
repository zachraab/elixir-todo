defmodule ToDoListWeb.NotFoundError do
  defexception message: "Page Not Found", plug_status: 404
end
