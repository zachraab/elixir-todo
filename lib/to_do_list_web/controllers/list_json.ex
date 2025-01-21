defmodule ToDoListWeb.ListJSON do
  alias ToDoList.Lists.List

  @doc """
  Renders a list of lists.
  """
  def index(%{lists: lists}) do
    %{data: for(list <- lists, do: data(list))}
  end

  @doc """
  Renders a single list.
  """
  def show(%{list: list}) do
    %{data: data(list)}
  end

  defp data(%List{} = list) do
    %{
      id: list.id,
      list_name: list.list_name,
      items: list.items,
      user_id: list.user_id
    }
  end
end
