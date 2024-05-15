defmodule LivePoll.Repo.Migrations.CreateOptionsTable do
  use Ecto.Migration

  def change do
    create table(:options) do
      add :option_name, :string, null: false

      timestamps()
    end
  end
end
