defmodule ToDoListWeb.HelpersTest do
  import ToDoListWeb.Helpers
  use ToDoListWeb.ConnCase

  describe "active_class/2" do
    test "returns active class when path matches request path", %{conn: conn} do
      conn = %{conn | request_path: "/home"}

      result = active_class(conn, "/home")

      assert result == "border-black border-b-2"
    end

    test "returns empty string when path does not match request path", %{conn: conn} do
      conn = %{conn | request_path: "/about"}

      result = active_class(conn, "/home")

      assert result == ""
    end
  end
end
