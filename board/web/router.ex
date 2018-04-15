defmodule Board.Router do
  use Board.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Board.Auth, repo: Board.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Board do
    pipe_through :browser

    get "/", PageController, :index
    post "/register", RegistrationController, :create
    get "/register", RegistrationController, :new
    post "/login", SessionController, :create    
    get "/login", SessionController, :new
    delete "/login", SessionController, :delete
    resources "/profile", ProfileController, singleton: true, only: [:show]
    resources "/t", TopicController do
      resources "/posts", PostController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Board do
  #   pipe_through :api
  # end
end
