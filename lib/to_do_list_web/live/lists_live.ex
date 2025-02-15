defmodule ToDoListWeb.ListsLive do
  use ToDoListWeb, :live_view
  alias ToDoList.Accounts
  alias ToDoList.Lists
  alias ToDoListWeb.DeleteListComponent

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

  def handle_event("search_list", %{"search_query" => search_query}, socket) do
    trimmed_query = String.trim(search_query)
    {:noreply, assign(socket, search_query: trimmed_query)}
  end

  def handle_info({:list_deleted, updated_lists, deleted_list_name}, socket) do
    current_user = socket.assigns.current_user
    filtered_lists = socket_filter_lists(updated_lists, current_user)
    {:noreply, socket |> assign(lists: filtered_lists) |> put_flash(:info, "The \"#{deleted_list_name}\" list has been successfully deleted.")}
  end
end
