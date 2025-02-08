defmodule ToDoListWeb.ListItemFormComponent do
  use ToDoListWeb, :live_component

  def update(assigns, socket) do
    form = to_form(%{"added_item" => ""})
    new_list_items = Map.get(assigns, :new_list_items, [])
    {:ok, assign(socket, list_item_form: form, new_list_items: new_list_items, class: [])}
  end

  def render(assigns) do
    ~H"""
    <div class={@class}>
      <.simple_form for={@list_item_form} phx-submit="add_item" phx-change="update_item" phx-target={@myself}>
        <.input field={@list_item_form[:added_item]} value={@list_item_form.params["added_item"]} label="Item" placeholder="Add new item..."/>
        <.button>Add Item</.button>
      </.simple_form>
    </div>
    """
  end

  # Handle List Items
  def handle_event("add_item", %{"added_item" => item}, socket) do
    trimmed_item = String.trim(item)
    IO.inspect(trimmed_item)
    if String.length(trimmed_item) > 0 do
      send(self(), {:add_list_item, trimmed_item})
      updated_form = to_form(%{"added_item" => ""})
      {:noreply, assign(socket, list_item_form: updated_form)}
    else
      send(self(), {:show_error, "Item cannot be empty"})
      {:noreply, assign(socket, list_item_form: to_form(%{"added_item" => item}))}
    end
  end

  def handle_event("update_item", %{"added_item" => item}, socket) do
    updated_form = to_form(%{"added_item" => item, "placeholder_value" => socket.assigns.list_item_form.params["placeholder_value"]})
    {:noreply, assign(socket, list_item_form: updated_form)}
  end
end
