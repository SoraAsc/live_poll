defmodule LivePoll.Models.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  alias LivePoll.Models.Option
  alias LivePoll.Models.PollCategory
  alias LivePoll.Models.Vote

  @fields [:title, :description, :image_url, :creator_ip]

  schema "polls" do
    field :title, :string
    field :description, :string
    field :image_url, :binary
    field :creator_ip, :string

    has_many :vote, Vote
    has_many :poll_category, PollCategory
    has_many :categories, through: [:poll_category, :category]
    has_many :option, Option

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required([:title, :creator_ip])
    |> validate_length(:title, min: 5)
  end
end
