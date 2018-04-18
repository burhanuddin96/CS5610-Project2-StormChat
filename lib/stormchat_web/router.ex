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

  # Other scopes may use custom stacks.
  scope "/api/v1", StormchatWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit, :index]
    resources "/alerts", AlertController, except: [:new, :edit, :create, :update, :delete]
    resources "/counties", CountyController, except: [:new, :edit, :index, :create, :update, :delete]
    resources "/locations", LocationController, except: [:new, :edit]
    resources "/location_counties", LocationCountyController, except: [:new, :edit, :index, :create, :update, :delete]
    resources "/posts", PostController, except: [:new, :edit, :index, :create, :update, :delete]
    post "/token", TokenController, :create
  end

  scope "/", StormchatWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/*path", PageController, :index
  end
end
