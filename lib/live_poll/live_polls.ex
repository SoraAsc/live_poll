defmodule LivePoll.LivePolls do

  import Ecto.Query, warn: false
  alias LivePoll.Models.Vote
  alias LivePoll.Models.{Option, Poll}
  alias LivePoll.Repo

  def create_poll(attrs_poll \\ %{}, attrs_option_list) do
    cond do
      length(attrs_option_list) < 2 ->
        {:error, "O número mínimo de opções é 2."}

      length(attrs_option_list) > 6 ->
        {:error, "Há mais opções do que o máximo esperado (6)."}

      true ->
        poll_changeset = Poll.changeset(attrs_poll)

        Repo.transaction(fn ->
          with {:ok, poll} <- Repo.insert(poll_changeset),
               {:ok, _options} <- insert_options(poll, attrs_option_list) do
            {:ok, poll}
          else
            {:error, changeset} -> Repo.rollback(changeset)
          end
        end)
    end
  end

  defp insert_options(poll, options_attrs) do
    options_changesets = Enum.map(options_attrs, fn option_attrs ->
      Option.changeset(Map.put(option_attrs, :poll_id, poll.id))
    end)

    case Enum.all?(options_changesets, &(&1.valid?)) do
      true ->
        Enum.each(options_changesets, &Repo.insert!/1)
        {:ok, options_changesets}
      false ->
        {:error, options_changesets |> Enum.find(&(!&1.valid?))}
    end
  end

  def list_polls do
    query = from p in Poll, select: %{id: p.id, title: p.title, image_url: p.image_url, ip: p.creator_ip}
    Repo.all(query)
  end

  def list_polls_filter(filters \\ %{}) do
    Poll
    |> select_polls_fields
    |> apply_field_filter(filters)
    |> apply_search_filter(filters)
    |> Repo.all()
  end

  defp select_polls_fields(query) do
    from p in query, select: %{id: p.id, title: p.title, image_url: p.image_url, ip: p.creator_ip}
  end

  defp apply_search_filter(query, %{search: search_term}) do
    from p in query, where: ilike(p.title, ^"%#{search_term}%")
  end

  defp apply_field_filter(query, %{field: {:vote, order}}) do
    from p in query,
    left_join: v in Vote, on: v.poll_id == p.id,
    group_by: p.id,
    order_by: [{^order, count(v.id)}]
  end
  defp apply_field_filter(query, %{field: {field_name, order}}) when field_name in [:title, :inserted_at] do
    from p in query, order_by: [{^order, ^field_name}]
  end

  # defp apply_category_filter(query, %{categories: categories}) when is_list(categories) do
  #   from p in query, where: p.category_id in ^categories
  # end

  def get_poll!(id) do
    try do
      poll = Repo.get!(Poll, id)
        |> Repo.preload(option: from(o in Option, select: %{id: o.id, name: o.option_name}))
        |> Repo.preload(:categories)
        # |> Repo.preload(:poll_category)
      IO.inspect(poll)
      poll
    rescue
      _ -> nil
    end
  end

  def count_votes(id) do
    Repo.one(from v in Vote, where: v.poll_id == ^id, select: count(v.id))
  end

  def already_voted(poll_id, vote_ip) do
    Vote
      |> where([v], v.poll_id == ^poll_id and v.vote_ip == ^vote_ip)
      |> select([v], v.option_id)
      |> Repo.one()
    # Repo.exists?(from v in Vote, where: ^vote_ip == v.vote_ip and ^poll_id == v.poll_id)
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
