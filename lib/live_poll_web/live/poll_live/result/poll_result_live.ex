defmodule LivePollWeb.PollLive.Result.PollResultLive do
  use LivePollWeb, :live_view
  import LivePoll.LivePolls

  def mount(%{"id" => id}, session, socket) do
    user_ip = Map.get(session, "user_ip")
    results = get_poll_results(id)
    options_list = Enum.map(results, fn %{option_name: p1} -> p1 end)
    votes_list = Enum.map(results, fn %{vote_count: p2} -> p2 end)
    # IO.inspect(options_list)
    {:ok, socket
      |> assign(:client_ip, user_ip)
      |> assign(:poll, get_poll!(id))
      |> assign(:options, options_list)
      |> assign(:votes, votes_list)
    }
  end
end
