defmodule ToDoListWeb.NewListLive do
  use ToDoListWeb, :live_view
  alias ToDoList.Accounts
  alias ToDoList.Lists
  alias ToDoListWeb.AddItemFormComponent

  def mount(_params, session, socket) do
    user_token = Map.get(session, "user_token")
    current_user = user_token && Accounts.get_user_by_session_token(user_token)

    {:ok, assign(socket,
      new_list_name: "",
      new_list_items: [],
      list_name_form: to_form(%{"new_list_name" => ""}),
      current_user: current_user
      )}
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
      {:ok, list} ->

        {:noreply,
         socket
         |> put_flash(:info, "The \"#{list.list_name}\" list was successfully saved!")
         |> assign(new_list_name: "",
                   new_list_items: [],
                   list_name_form: to_form(%{"new_list_name" => ""})
                  )
        }
      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to create list")}
    end
  end
end
