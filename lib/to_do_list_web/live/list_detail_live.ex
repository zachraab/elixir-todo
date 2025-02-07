defmodule ToDoListWeb.ListDetailLive do
  use ToDoListWeb, :live_view

  alias ToDoList.Lists
  alias ToDoListWeb.ListItemFormComponent

  def mount(%{"id" => id}, _session, socket) do
    try do
      form = to_form(%{})
      list = Lists.get_list!(id)
      {:ok, assign(socket, form: form, list: list)}
    rescue
      Ecto.NoResultsError ->
        {:ok, socket
        |> put_flash(:error, "List with ID: #{id} does not exist")
        |> redirect(to: ~p"/new-list")}
    end
  end

  defp update_list_items(socket, items_map) do
    list = socket.assigns.list

    items_list = items_map
    |> Enum.sort_by(fn {k, _} -> String.to_integer(k) end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.trim/1)
    case Lists.update_list(list, %{items: items_list}) do
      {:ok, updated_list} ->
        {:noreply, socket |> put_flash(:info, "List: #{list.list_name} was successfully updated") |> assign(list: updated_list)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to save changes to #{list.list_name} list")}
    end
  end

  def handle_info({:add_list_item, item}, socket) do
    current_items = socket.assigns.list.items
    current_items_map = current_items
    |> Enum.with_index()
    |> Enum.map(fn {item, index} -> {to_string(index), item} end)
    |> Enum.into(%{})

    new_index = length(current_items) |> Integer.to_string()
    new_items_map = Map.put(current_items_map, new_index, item)
    update_list_items(socket, new_items_map)
  end

  def handle_event("update_list", %{"items" => items_map}, socket) do
    update_list_items(socket, items_map)
  end
end
