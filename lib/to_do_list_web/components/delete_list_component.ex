defmodule ToDoListWeb.DeleteListComponent do
  use ToDoListWeb, :live_component
  alias ToDoList.Lists

  def update(assigns, socket) do
    {:ok, assign(socket, list_id: assigns.list_id, button_text: assigns.button_text)}
  end

  def render(assigns) do
    ~H"""
    <div>
    <.button phx-click="delete_list" phx-target={@myself} phx-value-id={@list_id}>{@button_text}</.button>
    </div>
    """
  end

  # Delete list from database
  def handle_event("delete_list", _params, socket) do
    list_id = socket.assigns.list_id

    case Lists.delete_list(list_id) do
      {:ok, list} ->
        updated_lists = Lists.list_lists()
        send(self(), {:list_deleted, updated_lists, list.list_name})
        {:noreply, socket |> put_flash(:info, "List: #{list.list_name} where ID: #{list.id} was successefully deleted")}
      {:error, _changeset} -> {:noreply, socket |> put_flash(:error, "Failed to delete list")}
    end
  end
end
