defmodule ToDoListWeb.ListLive do
  use ToDoListWeb, :live_view

  alias ToDoList.Lists

  def mount(_params, _session, socket) do
    list_name_form = to_form(%{"new_list_name" => ""})
    list_item_form = to_form(%{"added_item" => "", "placeholder_value" => "Type here..."})
    lists = Lists.list_lists()
    {:ok, assign(socket,
      new_list_name: "",
      rendered_list: [],
      list_name_form: list_name_form,
      list_item_form: list_item_form,
      lists: lists)
    }
  end

  def handle_event("set_list_name", %{"new_list_name" => list_name}, socket) do
    updated_form = to_form(%{"new_list_name" => list_name})
    {:noreply, assign(socket, new_list_name: list_name, list_name_form: updated_form)}
  end

  def handle_event("add_item", %{"added_item" => item}, socket) do
    updated_list = socket.assigns.rendered_list ++ [item]
    updated_form = to_form(%{socket.assigns.list_item_form.params | "added_item" => ""})
    {:noreply, assign(socket, rendered_list: updated_list, list_item_form: updated_form)}
  end

  def handle_event("validate_item", %{"added_item" => _item}, socket) do
    {:noreply, socket}
  end
end
