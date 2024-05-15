defmodule LivePoll.Models.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  alias LivePoll.Models.Option
  alias LivePoll.Models.Poll

  @fields [:vote_ip, :poll_id, :option_id]

  schema "votes" do
    field :vote_ip, :string

    belongs_to :option, Option
    belongs_to :poll, Poll

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@fields)
  end

end
