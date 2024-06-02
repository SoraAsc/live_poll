defmodule LivePollWeb.Layouts.Dropdown.Dropdown do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  defp pick_option(name, id, event) do
    toogle_dropdown_menu(id)
    |> JS.push(event, value: %{value: name})
  end

  defp toogle_dropdown_menu(id) do
    JS.toggle(
      to: "#"<>id,
      display: "flex",
      in: {"transition ease-out duration-100", "transform opacity-0 scale-y-0", "transform opacity-100 scale-y-100"},
      out: {"transition ease-in duration-100", "transform opacity-100 scale-y-100", "transform opacity-0 scale-y-0"}
    )
  end

  def select_dropdown(assigns) do
    ~H"""
      <div class="dropdown_select">
        <div class="flex justify-between items-center h-full w-full px-2"
          phx-click={toogle_dropdown_menu(@id)}>
          <svg phx-click="change_sort_order_select" class="svg-button" viewBox="0 0 16 16">
            <%= if @sort_order == "desc" do %>
              <path d="M3.5 2.5a.5.5 0 0 0-1 0v8.793l-1.146-1.147a.5.5 0 0 0-.708.708l2 1.999.007.007a.497.497 0 0 0 .7-.006l2-2a.5.5 0 0 0-.707-.708L3.5 11.293zm3.5 1a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"/>
            <% else %>
              <path d="M3.5 12.5a.5.5 0 0 1-1 0V3.707L1.354 4.854a.5.5 0 1 1-.708-.708l2-1.999.007-.007a.5.5 0 0 1 .7.006l2 2a.5.5 0 1 1-.707.708L3.5 3.707zm3.5-9a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5M7.5 6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1zm0 3a.5.5 0 0 0 0 1h1a.5.5 0 0 0 0-1z"/>
            <% end %>
          </svg>
          <span><%= @current_filter %></span>
          <span class="hero-chevron-down cursor-pointer"></span>
        </div>
        <div id={@id} class="dropdown_select_menu" hidden="true"
          phx-click-away={toogle_dropdown_menu(@id)}
        >
          <%= for %{name: name} <- @options do %>
            <span phx-value-value={name} phx-click={pick_option(name, @id, @event)}
              class="hover:bg-quartiary hover:text-primary cursor-pointer px-2">
              <%= name %>
            </span>
          <% end %>
        </div>
      </div>
    """
  end

  def select_dropdown_multiple(assigns) do
    ~H"""
      <div class="dropdown_select">
        <div class="flex justify-between items-center h-full w-full px-2"
          phx-click={toogle_dropdown_menu(@id)}>
          <%= if length(@selecteds) <= 0 do %>
            <span class="text-quartiary/50 text-sm">Filter by Category</span>
          <% else %>
            <div class="flex truncate">
              <%= for item <- @selecteds do %>
                <div class="rounded-xl py-1 px-2 space-x-1 flex items-center text-sm bg-tertiary">
                  <span><%= item %></span>
                  <span phx-value-value={item} phx-click={@event} class="cursor-pointer hero-x-mark w-4 h-4"/>
                </div>
              <% end %>
            </div>
          <% end %>
          <span class="hero-chevron-down cursor-pointer"></span>
        </div>
        <div id={@id} class="dropdown_select_menu" hidden="true"
          phx-click-away={toogle_dropdown_menu(@id)}
        >
          <%= for %{name: name} <- @options do %>
            <span phx-value-value={name} phx-click={@event}
              class={" #{if Enum.member?(@selecteds, name), do: "before:hero-check-circle-solid before:w-4 before:h-4"} hover:bg-quartiary hover:text-primary cursor-pointer px-2"}>
              <%= name %>
            </span>
          <% end %>
        </div>
      </div>
    """
  end
end
