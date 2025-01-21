defmodule ToDoList.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :items, {:array, :string}
    field :list_name, :string
    belongs_to :user, ToDoList.Users.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:list_name, :items, :user_id])
    |> validate_required([:list_name, :items])
  end
end
