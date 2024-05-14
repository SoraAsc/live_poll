defmodule LivePoll.Repo.Migrations.AddReferencesIntoTables do
  use Ecto.Migration

  def change do
    alter table(:options) do
      add :poll_id, references(:polls)
    end
    alter table(:categories) do
      add :poll_id, references(:polls)
    end
    alter table(:votes) do
      add :poll_id, references(:polls)
      # User
    end
  end
end
