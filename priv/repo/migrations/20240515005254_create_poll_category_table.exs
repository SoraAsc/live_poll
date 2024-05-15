defmodule LivePoll.Repo.Migrations.CreatePollCategoryTable do
  use Ecto.Migration

  def change do
    create table(:poll_categories) do
      add :poll_id, references(:polls, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)
      timestamps()
    end
  end
end
