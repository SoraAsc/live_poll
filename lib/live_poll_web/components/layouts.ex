defmodule LivePollWeb.Layouts do
  use LivePollWeb, :html
  import LivePollWeb.Layouts.Button.Button

  embed_templates "layouts/*"
end
