defmodule LivePollWeb.Layouts.CustomInput.CustomInput do
  use Phoenix.Component

  attr :field, :map, default: %{}
  attr :type, :string, default: "text"
  attr :class, :string, default: ""
  attr :rest, :global, include: ~w(disabled form name value required)
  def custom_input(assigns) do
    ~H"""
    <div phx-feedback-for={@field.name}>
      <input
        type={@type}
        name={@field.name}
        id={@field.id || @field.name}
        value={Phoenix.HTML.Form.normalize_value(@type, @field.value)}
        class={[@class]}
        {@rest}
      />
      <.error :for={msg <- @field.errors}><%= msg %></.error>
    </div>
    """
  end

  attr :field, :map, default: %{}
  attr :class, :string, default: ""
  attr :rest, :global, include: ~w(disabled form name value)
  def custom_input_area(assigns) do
    ~H"""
    <div phx-feedback-for={@field.name}>
      <textarea
        name={@field.name}
        id={@field.id || @field.name}
        value={@field.value}
        class={[@class]}
        {@rest}
      />
      <.error :for={msg <- @field.errors}><%= msg %></.error>
    </div>
    """
  end

  def error(assigns) do
    ~H"""
    <p class="phx-no-feedback:hidden">
      <%= render_slot(@inner_block) %>
    </p>
    """
  end
end
