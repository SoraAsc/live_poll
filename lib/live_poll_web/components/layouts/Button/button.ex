defmodule LivePollWeb.Layouts.Button.Button do
  use Phoenix.Component

  def default_button(assigns) do
    ~H"""
      <button class="bg-secondary p-2 pr-6 pl-6 rounded-lg shadow-md hover:bg-primary transition-all"><%= @text %></button>
    """
  end
  def default_button_red(assigns) do
    ~H"""
      <button class="bg-tertiary p-2 pr-6 pl-6 rounded-lg shadow-md hover:bg-primary transition-all"><%= @text %></button>
    """
  end

  # def default_button_rounded(assigns) do
  #   ~H"""
  #     <button><%= @text %></button>
  #   """
  # end
end
