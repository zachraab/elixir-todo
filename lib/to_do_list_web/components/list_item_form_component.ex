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
    if String.trim(item) != "" do
      send(self(), {:add_list_item, item})
      updated_form = to_form(%{"added_item" => ""})
      {:noreply, assign(socket, list_item_form: updated_form)}
    else
      {:noreply, socket |> put_flash(:error, "Item cannot be empty") |> assign(list_item_form: to_form(%{"added_item" => ""}))}
    end
  end

  def handle_event("update_item", %{"added_item" => item}, socket) do
    updated_form = to_form(%{"added_item" => item, "placeholder_value" => socket.assigns.list_item_form.params["placeholder_value"]})
    {:noreply, assign(socket, list_item_form: updated_form)}
  end
end
