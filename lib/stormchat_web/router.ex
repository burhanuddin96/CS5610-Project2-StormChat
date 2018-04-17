defmodule StormchatWeb.Router do
  use StormchatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StormchatWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/home", PageController, :index
    get "/alert/:alert_id", PageController, :index
    # post "/session", SessionController, :create
    # delete "/session", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", StormchatWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/alerts", AlertController, except: [:new, :edit]
    resources "/counties", CountyController, except: [:new, :edit]
    resources "/locations", LocationController, except: [:new, :edit]
    resources "/location_counties", LocationCountyController, except: [:new, :edit]
    resources "/posts", PostController, except: [:new, :edit]
    post "/token", TokenController, :create
  end
end
