defmodule StormchatWeb.TokenController do
  use StormchatWeb, :controller

  alias Stormchat.Users
  alias Stormchat.Users.User

  action_fallback StormchatWeb.FallbackController

  # creates a token for future authentication
  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Users.get_and_auth_user(email, password) do
      token = Phoenix.Token.sign(conn, "auth token", user.id)
      conn
      |> put_status(:created)
      |> render("token.json", user: user, token: token)
    end
  end
end
