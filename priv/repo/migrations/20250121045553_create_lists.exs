defmodule ToDoList.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :list_name, :string
      add :items, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end
