defmodule LivePollWeb.PollLive.Inspect.PollInspectLive do
  alias Phoenix.PubSub
  use LivePollWeb, :live_view
  import LivePoll.LivePolls
  def mount(%{"id" => id}, session, socket) do

    case get_poll!(id) do
      nil ->
        {:ok, socket
          |> put_flash(:error, "Essa página não existe!")
          |> push_redirect(to: "/")}
      poll ->
        if(connected?(socket)) do
          PubSub.subscribe(LivePoll.PubSub, "vote_counter#{id}")
        end

        user_ip = Map.get(session, "user_ip")
        {:ok, socket
          |> assign(:client_ip, user_ip)
          |> assign(:poll, poll)
          |> assign(:selected_option, already_voted(poll.id, user_ip))
          |> assign(:votes_count, formart_votes(count_votes(id)))
        }
    end
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
       {:noreply, put_flash(socket, :error, "Opção inválida solicitada.")}
      option ->
        ip = socket.assigns.client_ip
        poll_id = socket.assigns.poll.id
        option_id = option.id
        perform_vote(%{vote_ip: ip, poll_id: poll_id, option_id: option_id})
        PubSub.broadcast(LivePoll.PubSub, "vote_counter#{socket.assigns.poll.id}", :refresh_vote)
        {:noreply, socket
          |> assign(:selected_option, option_id)
          |> put_flash(:info, "Voto realizado com sucesso!")}
    end
  end

  def handle_info(:refresh_vote, socket) do
    {:noreply, socket
    |> assign(:votes_count, formart_votes(count_votes(socket.assigns.poll.id)))}
  end
end
