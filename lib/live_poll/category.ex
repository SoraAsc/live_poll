defmodule LivePoll.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias LivePoll.Poll

  @fields [:name, :description, :poll_id]

  schema "categories" do
    field :name, :string
    field :description, :string

    belongs_to :poll, Poll

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
  end

end
