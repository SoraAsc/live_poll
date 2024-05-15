defmodule LivePoll.Repo.Migrations.CreatePollsTable do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :title, :string, null: false
      add :description, :text
      add :image_url, :binary
      add :creator_ip, :string, null: false

      timestamps()
    end
  end
end
