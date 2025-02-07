defmodule ToDoListWeb.ListLive do
  use ToDoListWeb, :live_view

  alias ToDoList.Lists
  alias ToDoListWeb.ListItemFormComponent

  def mount(_params, _session, socket) do
    list_name_form = to_form(%{"new_list_name" => ""})
    lists = Lists.list_lists()
    {:ok, assign(socket,
      new_list_name: "",
      new_list_items: [],
      list_name_form: list_name_form,
      lists: lists)
    }
  end

  def handle_info({:add_list_item, item}, socket) do
    updated_list = socket.assigns.new_list_items ++ [item]
    {:noreply, assign(socket, new_list_items: updated_list)}
  end

  # Handle List Name
  def handle_event("set_list_name", %{"new_list_name" => list_name}, socket) do
    if String.trim(list_name) != "" do
      updated_form = to_form(%{"new_list_name" => ""})
      {:noreply, assign(socket, new_list_name: list_name, list_name_form: updated_form)}
    else
      {:noreply, socket |> put_flash(:error, "List name cannot be empty") |> assign(list_name_form: to_form(%{"new_list_name" => ""}))}
    end
  end

  def handle_event("update_list_name", %{"new_list_name" => name}, socket) do
    updated_form = to_form(%{"new_list_name" => name})
    {:noreply, assign(socket, list_name_form: updated_form)}
  end

  # Write list to database
  def handle_event("create_list", _params, socket) do
    case Lists.create_list(%{list_name: socket.assigns.new_list_name, items: socket.assigns.new_list_items}) do
      {:ok, _list} ->
        updated_lists = Lists.list_lists()
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
    list_id = String.to_integer(id)
    case Lists.delete_list(list_id) do
      {:ok, list} ->
        updated_lists = Lists.list_lists()
        {:noreply, socket |> put_flash(:info, "List: #{list.list_name} where ID: #{list.id} was successefully deleted") |> assign(lists: updated_lists)}
      {:error, _changeset} -> {:noreply, socket |> put_flash(:error, "Failed to delete list")}
    end
  end
end
