defmodule LivePoll.Models.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias LivePoll.PollCategory

  @fields [:name, :description]

  schema "categories" do
    field :name, :string
    field :description, :string

    has_many :poll_category, PollCategory

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
  end

end
