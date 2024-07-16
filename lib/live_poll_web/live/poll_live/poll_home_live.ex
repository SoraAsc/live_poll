defmodule LivePollWeb.PollLive.PollHomeLive do
  use LivePollWeb, :live_view
  import LivePoll.LivePolls
  import LivePollWeb.Layouts.Dropdown.Dropdown

  def mount(_params, session, socket) do
    user_ip = Map.get(session, "user_ip")
    {:ok, socket
      |> assign(:client_ip, user_ip)
      |> assign(:polls, list_polls())
      |> assign(:selected_filter, "Date")
      |> assign(:sort_order, "asc")
      |> assign(:desired_categories, [])
      |> assign(:filters, %{:search => "", field: {:title, :asc}})
    }
  end

  def handle_event("search", %{"search" => search_term}, socket) do
    updated_map = Map.put(socket.assigns.filters, :search, search_term)
    {:noreply, socket
      |> assign(:polls, list_polls_filter(updated_map))
      |> assign(:filters, updated_map)
    }
  end

  def handle_event("pick_option_select", %{"value" => value}, socket) do
    {_, sort} = socket.assigns.filters.field
    option = case value do
      "Vote" -> :vote
      "Date" -> :inserted_at
      _ -> :title
    end
    updated_map = Map.put(socket.assigns.filters, :field, {option, sort})
    {:noreply, socket
      |> assign(:selected_filter, value)
      |> assign(:filters, updated_map)
      |> assign(:polls, list_polls_filter(updated_map))
    }
  end

  def handle_event("change_sort_order_select", _params, socket) do
    sort = if socket.assigns.sort_order == "asc", do: "desc", else: "asc"
    {field, _} = socket.assigns.filters.field
    updated_map = Map.put(socket.assigns.filters, :field, {field, String.to_atom(sort)})
    {:noreply, socket
      |> assign(:sort_order, sort)
      |> assign(:filters, updated_map)
      |> assign(:polls, list_polls_filter(updated_map))
    }
  end

  def handle_event("pick_options_m_select", %{"value" => value}, socket) do
    cats = delete_or_insert(socket.assigns.desired_categories, value)
    IO.inspect(value)
    {:noreply, socket
      |> assign(:desired_categories, cats)
    }
  end

  defp delete_or_insert(list, item) do
    case Enum.member?(list, item) do
      true -> Enum.filter(list, fn x -> x != item end)
      false -> [item | list]
    end
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
