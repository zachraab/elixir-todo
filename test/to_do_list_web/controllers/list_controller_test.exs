defmodule ToDoListWeb.ListControllerTest do
  use ToDoListWeb.ConnCase

  import ToDoList.ListsFixtures

  alias ToDoList.Lists.List

  @create_attrs %{
    items: ["option1", "option2"],
    list_name: "some list_name"
  }
  @update_attrs %{
    items: ["option1"],
    list_name: "some updated list_name"
  }
  @invalid_attrs %{items: nil, list_name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all lists", %{conn: conn} do
      conn = get(conn, ~p"/api/lists")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create list" do
    test "renders list when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/lists", list: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/lists/#{id}")

      assert %{
               "id" => ^id,
               "items" => ["option1", "option2"],
               "list_name" => "some list_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/lists", list: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update list" do
    setup [:create_list]

    test "renders list when data is valid", %{conn: conn, list: %List{id: id} = list} do
      conn = put(conn, ~p"/api/lists/#{list}", list: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/lists/#{id}")

      assert %{
               "id" => ^id,
               "items" => ["option1"],
               "list_name" => "some updated list_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, list: list} do
      conn = put(conn, ~p"/api/lists/#{list}", list: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete list" do
    setup [:create_list]

    test "deletes chosen list", %{conn: conn, list: list} do
      conn = delete(conn, ~p"/api/lists/#{list}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/lists/#{list}")
      end
    end
  end

  defp create_list(_) do
    list = list_fixture()
    %{list: list}
  end
end
