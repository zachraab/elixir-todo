defmodule ToDoList.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ToDoList.Lists` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        items: ["option1", "option2"],
        list_name: "some list_name"
      })
      |> ToDoList.Lists.create_list()

    list
  end
end
