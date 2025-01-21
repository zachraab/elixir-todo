defmodule ToDoList.Repo.Migrations.AddUserIdToLists do
  use Ecto.Migration

  def change do
    alter table(:lists) do
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
