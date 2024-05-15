defmodule LivePoll.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  alias LivePoll.Category

  @fields [:title, :description, :image_url, :creator_ip]

  schema "polls" do
    field :title, :string
    field :description, :string
    field :image_url, :binary
    field :creator_ip, :string

    has_many :category, Category

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required([:title, :creator_ip])
    |> validate_length(:title, min: 4)
  end
end
