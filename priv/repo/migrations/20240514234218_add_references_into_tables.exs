defmodule LivePoll.Repo.Migrations.AddReferencesIntoTables do
  use Ecto.Migration

  def change do
    alter table(:options) do
      add :poll_id, references(:polls, on_delete: :delete_all)
    end

    alter table(:votes) do
      add :poll_id, references(:polls, on_delete: :delete_all)
      # User
      add :option_id, references(:options, on_delete: :delete_all)
    end

    create unique_index(:votes, [:poll_id, :vote_ip])
  end
end
