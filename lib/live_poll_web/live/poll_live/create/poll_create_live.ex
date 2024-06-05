defmodule LivePollWeb.PollLive.Create.PollCreateLive do
  alias LivePoll.Models.Poll
  use LivePollWeb, :live_view
  import LivePoll.LivePolls

  def mount(_params, session, socket) do
    user_ip = Map.get(session, "user_ip")
    changeset = Poll.changeset(%{})
    {:ok, socket
      |> assign(:client_ip, user_ip)
      |> assign(:changeset, to_form(changeset))
    }
  end

  def handle_event("create_poll", %{"poll" => poll_params}, socket) do
    {:noreply, socket}
  end

end
