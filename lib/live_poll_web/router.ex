defmodule LivePollWeb.Router do
  use LivePollWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LivePollWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_user_ip
  end

  defp assign_user_ip(conn, _opts) do
    ip = conn.remote_ip |> Tuple.to_list() |> Enum.join(".")
    put_session(conn, :user_ip, ip)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/poll", LivePollWeb do
    pipe_through :browser

    live "/inspect/:id", PollLive.Inspect.PollInspectLive
    live "/result/:id", PollLive.Result.PollResultLive
  end

  scope "/", LivePollWeb do
    pipe_through :browser

    live "/", PollLive.PollHomeLive
    live "/create", PollLive.Create.PollCreateLive

    live "/*path", PollLive.Error404Live.Error404Live
  end



  # Other scopes may use custom stacks.
  # scope "/api", LivePollWeb do
  #   pipe_through :api
  # end
end
