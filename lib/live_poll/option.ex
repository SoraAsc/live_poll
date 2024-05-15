defmodule LivePoll.Option do
  use Ecto.Schema
  import Ecto.Changeset

  alias LivePoll.Poll

  @fields [:option_name, :poll_id]

  schema "options" do
    field :option_name, :string

    belongs_to :poll, Poll

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@fields)
  end

end
