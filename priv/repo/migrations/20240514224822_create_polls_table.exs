defmodule LivePoll.Repo.Migrations.CreatePollsTable do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :title, :string
      add :description, :text
      add :image_url, :binary
      add :creator_ip, :string

      timestamps()
    end
  end
end
