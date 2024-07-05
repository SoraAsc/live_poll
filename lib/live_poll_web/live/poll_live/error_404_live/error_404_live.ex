defmodule LivePollWeb.PollLive.Error404Live.Error404Live do
  use LivePollWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="error_404">
      <h1 class="text-4xl">Página Não Encontrada</h1>
      <p class="font-inter">A página que você está tentando acessar não existe.</p>
      <.link navigate={~p"/"}
        class="text-2xl text-quartiary rounded-full border border-quartiary px-8 py-2
          hover:bg-quartiary hover:text-quinary transition-colors">
        Voltar para Home
      </.link>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
