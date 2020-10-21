defmodule Table.Router do
  use Table, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {Table.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Table do
    pipe_through :browser

    live "/", TableLive
    live "/t/:id", GridLive
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: Table.Telemetry
    end
  end
end
