defmodule LivePoll.Models.Option do
  use Ecto.Schema
  import Ecto.Changeset

  alias LivePoll.Models.Vote
  alias LivePoll.Models.Poll

  @fields [:option_name, :poll_id]

  schema "options" do
    field :option_name, :string

    belongs_to :poll, Poll
    has_many :vote, Vote

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_length(:option_name, min: 1)
  end
end
