defmodule LivePoll.Repo.Migrations.CreateVotesTable do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :vote_ip, :string, null: false

      timestamps()
    end
  end
end
