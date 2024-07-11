defmodule LivePollWeb.Layouts.Button.Button do
  use Phoenix.Component

  def default_button(assigns) do
    ~H"""
      <button class="default-button bg-secondary hover:bg-primary"><%= @text %></button>
    """
  end

  def default_button_red(assigns) do
    ~H"""
      <button class="default-button bg-tertiary hover:bg-primary"><%= @text %></button>
    """
  end
end
