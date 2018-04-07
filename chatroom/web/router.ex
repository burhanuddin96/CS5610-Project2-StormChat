defmodule Faster.Router do
  use Faster.Web, :router

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

  scope "/", Faster do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController, only: [:new, :create]

    get "/login", SessionController, :new     
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    post "/send", MessageController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", Faster do
  #   pipe_through :api
  # end
end
