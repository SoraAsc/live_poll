defmodule LivePoll.Repo.Migrations.CreateVotesTable do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :vote_ip, :string

      timestamps()
    end

    create unique_index(:votes, [:vote_ip])
  end
end
