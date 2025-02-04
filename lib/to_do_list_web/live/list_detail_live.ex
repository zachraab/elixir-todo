defmodule ToDoListWeb.ListDetailLive do
  use ToDoListWeb, :live_view

  alias ToDoList.Lists

  def mount(%{"id" => id}, _session, socket) do
    update_list_form = to_form(%{})
    list = Lists.get_list!(id)
    {:ok, assign(socket, update_list_form: update_list_form, list: list)}
  end
end
