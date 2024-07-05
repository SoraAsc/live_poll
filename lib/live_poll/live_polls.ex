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
    query = from p in Poll, select: %{id: p.id, title: p.title, image_url: p.image_url, ip: p.creator_ip}
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
    Repo.one(from v in Vote, where: v.poll_id == ^id, select: count(v.id))
  end

  def already_voted(poll_id, vote_ip) do
    Repo.exists?(from v in Vote, where: ^vote_ip == v.vote_ip and ^poll_id == v.poll_id)
  end

  def perform_vote(attrs_vote) do
    attrs_vote
      |> Vote.changeset()
      |> Repo.insert(on_conflict: {:replace, [:option_id]}, conflict_target: [:poll_id, :vote_ip])
  end

  def delete_poll(poll_id, creator_ip) do
    query = from(p in Poll, where: p.id == ^poll_id and p.creator_ip == ^creator_ip)
    case Repo.delete_all(query) do
      {0, nil} -> {:error, "You can't delete this poll"}
      _ -> {:ok, "Poll deleted"}
    end
  end

  def get_poll_results(poll_id) do
    query = from o in Option,
      left_join: v in Vote, on: o.id == v.option_id,
      group_by: o.option_name,
      where: o.poll_id == ^poll_id,
      select: %{option_name: o.option_name, vote_count: count(v.id)}
    Repo.all(query)
  end
end
