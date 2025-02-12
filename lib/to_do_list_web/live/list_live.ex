defmodule ToDoListWeb.ListLive do
  use ToDoListWeb, :live_view
  alias ToDoList.Accounts
  alias ToDoList.Lists
  alias ToDoListWeb.ListItemFormComponent

  def mount(_params, session, socket) do
    user_token = Map.get(session, "user_token")
    current_user = user_token && Accounts.get_user_by_session_token(user_token)

    common_assigns = %{
      new_list_name: "",
      new_list_items: [],
      list_name_form: to_form(%{"new_list_name" => ""}),
      search_form: to_form(%{"search_query" => ""}),
      search_query: "",
      current_user: current_user
    }

    lists = Lists.list_lists()
    filtered_lists = socket_filter_lists(lists, current_user)

    {:ok, assign(socket, Map.merge(common_assigns, %{lists: filtered_lists}))}
  end

  defp socket_filter_lists(lists, nil), do: Enum.filter(lists, &is_nil(&1.user_id))
  defp socket_filter_lists(lists, current_user), do: Enum.filter(lists, &(&1.user_id == nil or &1.user_id == current_user.id))

  defp filter_lists(lists, nil), do: lists
  defp filter_lists(lists, ""), do: lists
  defp filter_lists(lists, query) do
    Enum.filter(lists, fn list ->
      String.contains?(String.downcase(list.list_name), String.downcase(query))
    end)
  end

  def handle_info({:add_list_item, item}, socket) do
    updated_list = socket.assigns.new_list_items ++ [item]
    {:noreply, assign(socket, new_list_items: updated_list)}
  end

  def handle_info({:show_error, message}, socket) do
    {:noreply, put_flash(socket, :error, message)}
  end

  # Handle List Name
  def handle_event("set_list_name", %{"new_list_name" => list_name}, socket) do
    trimmed_list_name = String.trim(list_name)
    IO.inspect(trimmed_list_name)
    if String.length(trimmed_list_name) > 0 do
      updated_form = to_form(%{"new_list_name" => ""})
      {:noreply, assign(socket, new_list_name: trimmed_list_name, list_name_form: updated_form)}
    else
      {:noreply, socket |> put_flash(:error, "List name cannot be empty") |> assign(list_name_form: to_form(%{"new_list_name" => ""}))}
    end
  end

  def handle_event("update_list_name", %{"new_list_name" => name}, socket) do
    updated_form = to_form(%{"new_list_name" => name})
    {:noreply, assign(socket, list_name_form: updated_form)}
  end

  # Write list to database
  def handle_event("create_list", _params, socket) do\
    current_user = socket.assigns.current_user
    case Lists.create_list(%{list_name: socket.assigns.new_list_name, items: socket.assigns.new_list_items, user_id: current_user && current_user.id}) do
      {:ok, _list} ->
        lists = Lists.list_lists()
        updated_lists = socket_filter_lists(lists, current_user)
        {:noreply,
         socket
         |> put_flash(:info, "List saved successfully!")
         |> assign(new_list_name: "",
                   new_list_items: [],
                   list_name_form: to_form(%{"new_list_name" => ""}),
                   list_item_form: to_form(%{"added_item" => ""}),
                   lists: updated_lists
                  )
        }
      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to create list")}
    end
  end

  # Delete list from database
  def handle_event("delete_list", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user
    list_id = String.to_integer(id)
    case Lists.delete_list(list_id) do
      {:ok, list} ->
        lists = Lists.list_lists()
        updated_lists = socket_filter_lists(lists, current_user)
        {:noreply, socket |> put_flash(:info, "List: #{list.list_name} where ID: #{list.id} was successefully deleted") |> assign(lists: updated_lists)}
      {:error, _changeset} -> {:noreply, socket |> put_flash(:error, "Failed to delete list")}
    end
  end

  def handle_event("search_list", %{"search_query" => search_query}, socket) do
    trimmed_query = String.trim(search_query)
    {:noreply, assign(socket, search_query: trimmed_query)}
  end
end
