defmodule LivePoll.PollCategory do
  use Ecto.Schema
  import Ecto.Changeset

  alias LivePoll.Category
  alias LivePoll.Poll

  @fields [:poll_id, :category_id]

  schema "votes" do
    field :vote_ip, :string

    belongs_to :category, Category
    belongs_to :poll, Poll

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
