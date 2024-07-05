defmodule LivePollWeb.PollLive.Result.PollResultLive do
  alias Phoenix.PubSub
  use LivePollWeb, :live_view
  import LivePoll.LivePolls

  def mount(%{"id" => id}, session, socket) do
    if(connected?(socket)) do
      PubSub.subscribe(LivePoll.PubSub, "vote_counter#{id}")
    end
    user_ip = Map.get(session, "user_ip")
    results = get_poll_results(id)
    options_list = Enum.map(results, fn %{option_name: p1} -> p1 end)
    votes_list = Enum.map(results, fn %{vote_count: p2} -> p2 end)
    {:ok, socket
      |> assign(:client_ip, user_ip)
      |> assign(:poll, get_poll!(id))
      |> assign(:options, options_list)
      |> assign(:votes, votes_list)
    }
  end

  def handle_info(:refresh_vote, socket) do
    votes_list = Enum.map(get_poll_results(socket.assigns.poll.id), fn %{vote_count: p2} -> p2 end)
    {:noreply, socket
      |> assign(:votes, votes_list)}
  end
end
