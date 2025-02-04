defmodule ToDoListWeb.ListDetailLive do
  use ToDoListWeb, :live_view

  alias ToDoList.Lists

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

  def handle_event("update_list", %{"items" => items_map}, socket) do
    list = socket.assigns.list
    updated_items = items_map
    |> Enum.sort_by(fn {k, _} -> String.to_integer(k) end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.trim/1)

    case Lists.update_list(list, %{items: updated_items}) do
      {:ok, updated_list} ->
        {:noreply, assign(socket, list: updated_list)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to save changes to #{list.list_name} list")}
    end
  end

end
