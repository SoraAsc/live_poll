defmodule LivePollWeb.PollLive.PollHomeLive do
  use LivePollWeb, :live_view
  import LivePoll.LivePolls
  import LivePollWeb.Layouts.Dropdown.Dropdown

  def mount(_params, session, socket) do
    user_ip = Map.get(session, "user_ip")
    {:ok, socket
      |> assign(:client_ip, user_ip)
      |> assign(:polls, list_polls())
      |> assign(:selected_filter, "Name")
      |> assign(:sort_order, "asc")
    }
  end

  def handle_event("pick_option_select", %{"value" => value}, socket) do
    {:noreply, socket
      |> assign(:selected_filter, value)
    }
  end

  def handle_event("change_sort_order_select", _params, socket) do
    sort = if socket.assigns.sort_order == "asc", do: "desc", else: "asc"
    {:noreply, socket
      |> assign(:sort_order, sort)
    }
  end

  # defp get_public_ip do
  #   "https://api.ipify.org?format=json"
  #   |> HTTPoison.get()
  #   |> case do
  #     {:ok, %HTTPoison.Response{body: body}} ->
  #       {:ok, data} = Jason.decode(body)
  #       Map.get(data, "ip")
  #     _ ->
  #       "Unknown"
  #   end
  # end

end
