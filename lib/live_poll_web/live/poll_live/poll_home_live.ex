defmodule LivePollWeb.PollLive.PollHomeLive do
  use LivePollWeb, :live_view
  import LivePoll.LivePolls

  def mount(_params, session, socket) do
    user_ip = Map.get(session, "user_ip")
    {:ok, socket
      |> assign(:client_ip, user_ip)
      |> assign(:polls, list_polls())
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
