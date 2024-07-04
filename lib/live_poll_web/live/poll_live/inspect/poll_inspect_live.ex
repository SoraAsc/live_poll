defmodule LivePollWeb.PollLive.Inspect.PollInspectLive do
  alias Phoenix.PubSub
  use LivePollWeb, :live_view
  import LivePoll.LivePolls
  def mount(%{"id" => id}, session, socket) do
    if(connected?(socket)) do
      PubSub.subscribe(LivePoll.PubSub, "vote_counter#{id}")
    end

    user_ip = Map.get(session, "user_ip")
    {:ok, socket
      |> assign(:client_ip, user_ip)
      |> assign(:poll, get_poll!(id))
      |> assign(:votes_count, formart_votes(count_votes(id)))
    }
  end

  defp formart_votes(num) do
    num
    |> Integer.to_string()
    |> String.reverse()
    |> String.replace(~r/\d{3}(?=\d)/, "\\0.")
    |> String.reverse()
  end


  def handle_event("vote", %{"Options" => selected_option_id}, socket) do
    case Enum.find(socket.assigns.poll.options, fn option -> to_string(option.id) == selected_option_id end) do
      nil ->
        IO.inspect(selected_option_id)
       {:noreply, put_flash(socket, :error, "Opção inválida solicitada.")}
      option ->
        ip = socket.assigns.client_ip
        poll_id = socket.assigns.poll.id
        option_id = option.id
        perform_vote(%{vote_ip: ip, poll_id: poll_id, option_id: option_id})
        PubSub.broadcast(LivePoll.PubSub, "vote_counter#{socket.assigns.poll.id}", :refresh_vote)
        {:noreply, socket}
        # {:noreply, socket
        #   |> put_flash(:info, "Voto realizado com sucesso!")
        #   |> push_redirect(to: "/")}
    end
  end

  def handle_info(:refresh_vote, socket) do
    {:noreply, socket
    |> assign(:votes_count, formart_votes(count_votes(socket.assigns.poll.id)))}
  end
end
