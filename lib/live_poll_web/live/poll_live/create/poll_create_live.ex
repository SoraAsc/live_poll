defmodule LivePollWeb.PollLive.Create.PollCreateLive do
  use LivePollWeb, :live_view
  alias LivePoll.Models.Poll
  import LivePoll.LivePolls
  import LivePollWeb.Layouts.CustomInput.CustomInput
  import LivePollWeb.Layouts.Dropdown.Dropdown

  def mount(_params, session, socket) do
    user_ip = Map.get(session, "user_ip")
    changeset = Poll.changeset(%{})
    {:ok, socket
      |> assign(:client_ip, user_ip)
      |> assign(:changeset, to_form(changeset))
      |> assign(:options, [])
      |> assign(:desired_categories, [])
      |> assign(:errors, [])
    }
  end

  def handle_event("select_categories", %{"value" => value}, socket) do
    cats = delete_or_insert(socket.assigns.desired_categories, value)

    {:noreply, socket
      |> assign(:desired_categories, cats)
    }
  end

  def handle_event("handle_click", %{"input_value" => value}, socket) do
    if length(socket.assigns.options) < 6 do
      options = socket.assigns.options ++ [%{option_name: value}]
      {:noreply, socket
        |> assign(:options, options)
      }
    else
      {:noreply, socket}
    end
  end

  def handle_event("update_option", %{"index" => index, "value" => value}, socket) do
    options = List.update_at(socket.assigns.options, String.to_integer(index), fn _ -> %{option_name: value} end)
    {:noreply, assign(socket, :options, options)}
  end

  def handle_event("remove_option", %{"index" => index}, socket) do
    options = List.delete_at(socket.assigns.options, String.to_integer(index))
    {:noreply, assign(socket, :options, options)}
  end

  def handle_event("create_poll", %{"poll" => poll_params}, socket) do
    map = Map.put(poll_params, "creator_ip", socket.assigns.client_ip)

    result = Enum.filter(LivePoll.Utils.FilterOptions.categories, fn %{name: n} -> n in socket.assigns.desired_categories end)
    ids = Enum.map(result, fn %{id: i} -> i end)

    case create_poll(map, socket.assigns.options, ids) do
      {:ok, _poll} -> {:noreply, push_navigate(socket, to: "/")}

      {:error, message} when is_binary(message) -> {:noreply, put_flash(socket, :error, message)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: to_form(changeset), errors: format_changeset_errors(changeset))}
    end
  end

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  defp delete_or_insert(list, item) do
    case Enum.member?(list, item) do
      true -> Enum.filter(list, fn x -> x != item end)
      false -> list ++ [item] #[item | list]
    end
  end
end
