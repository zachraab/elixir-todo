defmodule ToDoListWeb.ListDetailLive do
  use ToDoListWeb, :live_view

  alias ToDoList.Accounts
  alias ToDoList.Lists
  alias ToDoListWeb.AddItemFormComponent
  alias ToDoListWeb.DeleteListComponent

  def mount(%{"id" => id}, session, socket) do
    user_token = Map.get(session, "user_token")
    current_user = user_token && Accounts.get_user_by_session_token(user_token)

    try do
      form = to_form(%{})
      list = Lists.get_list!(id)
      {:ok, assign(socket, form: form, list: list, current_user: current_user)}
    rescue
      Ecto.NoResultsError ->
        {:ok, socket
        |> put_flash(:error, "List with ID: #{id} does not exist")
        |> redirect(to: ~p"/lists")}
    end
  end

  defp create_map_from_list(items_list) do
	items_list
	|> Enum.with_index()
	|> Enum.into(%{}, fn {item, index} -> {Integer.to_string(index), item} end)
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
        {:noreply, socket |> put_flash(:info, "The \"#{list.list_name}\" list was successfully updated.") |> assign(list: updated_list)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to save changes to the \"#{list.list_name}\" list.")}
    end
  end

  def handle_info({:add_list_item, item}, socket) do
    current_items = socket.assigns.list.items
    current_items_map = create_map_from_list(current_items)

    new_index = length(current_items) |> Integer.to_string()
    new_items_map = Map.put(current_items_map, new_index, item)
    update_list_items(socket, new_items_map)
  end

  def handle_info({:list_deleted, _updated_lists, deleted_list_name}, socket) do
    {:noreply, socket |> redirect(to: ~p"/lists") |> put_flash(:info, "The \"#{deleted_list_name}\" list has been successfully deleted.")}
  end

  def handle_info({:show_error, message}, socket) do
    {:noreply, put_flash(socket, :error, message)}
  end

  def handle_event("update_list", %{"items" => items_map}, socket) do
    update_list_items(socket, items_map)
  end

  def handle_event("delete_item", %{"index" => item_index}, socket) do
	list = socket.assigns.list
	current_items = socket.assigns.list.items

	remove_item = Enum.at(current_items, String.to_integer(item_index), nil)
	updated_items = List.delete(current_items, remove_item)
    updated_items_map = create_map_from_list(updated_items)

	update_list_items(socket, updated_items_map)

	{:noreply, socket |> put_flash(:info, "Successfully deleted item: \"#{remove_item}\"") |> assign(list: %{list | items: updated_items})}
  end
end
