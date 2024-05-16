defmodule LivePoll.LivePolls do

  import Ecto.Query, warn: false
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
    Repo.all(Poll)
  end

  def get_poll!(id), do: Repo.get!(Poll, id)

  # def create_poll(attrs \\ %{}) do
  #   %Poll{}
  #   |> Poll.changeset(attrs)
  #   |> Repo.insert()
  # end

  # def update_poll(%Poll{} = poll) do
  #   poll
  #   |> Poll.changeset()
  #   |> Repo.update()
  # end

  # def delete_poll(%Poll{} = poll) do
  #   Repo.delete(poll)
  # end

  # def change_poll(%Poll{} = poll, attrs \\ %{}) do
  #   Poll.changeset(poll, attrs)
  # end

end
