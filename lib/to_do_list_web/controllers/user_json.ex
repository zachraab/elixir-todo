defmodule ToDoListWeb.UserJSON do
  alias ToDoList.Accounts.User
  alias ToDoList.Lists.List

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      lists: for(list <- user.lists, do: list_data(list))
    }
  end

  defp list_data(%List{} = list) do
    %{
      id: list.id,
      list_name: list.list_name,
      lists: list.items
    }
  end
end
