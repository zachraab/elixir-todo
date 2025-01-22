defmodule ToDoListTest do
  use ExUnit.Case
  doctest ToDoList

  test "GET user list" do
    user_list = ["apple", "pie"]

    assert ToDoList.get_user_list("Frank", :groceries, ["apple", "pie"]) == user_list
  end
end
