defmodule LivePoll.Models.PollCategory do
  use Ecto.Schema
  import Ecto.Changeset

  alias LivePoll.Models.Category
  alias LivePoll.Models.Poll

  @fields [:poll_id, :category_id]

  schema "poll_categories" do
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
