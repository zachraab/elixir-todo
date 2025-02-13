defmodule ToDoListWeb.ListsLive do
  use ToDoListWeb, :live_view
  alias ToDoList.Accounts
  alias ToDoList.Lists

  def mount(_params, session, socket) do
    user_token = Map.get(session, "user_token")
    current_user = user_token && Accounts.get_user_by_session_token(user_token)

    common_assigns = %{
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
