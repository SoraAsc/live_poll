defmodule LivePoll.LivePolls do

  import Ecto.Query, warn: false
  alias LivePoll.Models.Vote
  alias LivePoll.Models.{Option, Poll}
  alias LivePoll.Repo

  def create_poll(attrs_poll \\ %{}, attrs_option_list) do
    if length(attrs_option_list) > 6 do
      {:error, "Há mais opções do que o máximo esperado(6)"}
    else
      Repo.transaction(fn ->
        {status, data} = attrs_poll
          |> Poll.changeset()
          |> Repo.insert()
        if status == :ok do
          attrs_option_list
            |> Enum.map(&create_option(&1, data.id))
        else
          {:error, data.errors}
        end
      end)
    end
  end

  defp create_option(attrs_option, poll_id) do
    {:ok, _option} = Map.put(attrs_option, :poll_id, poll_id)
      |> Option.changeset()
      |> Repo.insert()
  end

  def list_polls do
    query = from p in Poll, select: %{title: p.title, image_url: p.image_url, ip: p.creator_ip}
    Repo.all(query)
  end

  def get_poll!(id) do
    poll = Poll
      |> where([p], p.id == ^id)
      |> select([p], %{id: p.id, title: p.title, description: p.description})
      |> Repo.one!

    options = Option
      |> where([o], o.poll_id == ^poll.id)
      |> select([o], %{id: o.id, name: o.option_name})
      |> Repo.all
    Map.put(poll, :options, options)
    # Map.delete(Map.put(poll, :options, options), :id)
  end

  def count_votes(id) do
    Repo.one(from v in Vote, where: v.poll_id == ^id, select: count("*"))
  end

  def perform_vote(attrs_vote) do
    attrs_vote
      |> Vote.changeset()
      |> Repo.insert(on_conflict: {:replace, [:option_id]}, conflict_target: [:poll_id, :vote_ip])
  end

  # def update_poll(%Poll{} = poll) do
  #   poll
  #   |> Poll.changeset()
  #   |> Repo.update()
  # end

  def delete_poll(%Poll{} = poll) do
    Repo.delete(poll)
  end

  # def change_poll(%Poll{} = poll, attrs \\ %{}) do
  #   Poll.changeset(poll, attrs)
  # end

end
