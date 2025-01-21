defmodule ToDoList.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :items, {:array, :string}
    field :list_name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:list_name, :items])
    |> validate_required([:list_name, :items])
  end
end
