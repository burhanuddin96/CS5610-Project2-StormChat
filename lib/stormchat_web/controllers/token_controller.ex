defmodule StormchatWeb.TokenController do
  use StormchatWeb, :controller

  alias Stormchat.Users.User

  action_fallback StormchatWeb.FallbackController

  # creates a token for future authentication
  def create(conn, _params) do
    token = assigns(conn, :token)

    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        if user_id do
          conn
          |> put_status(:created)
          |> render("token.json", user_id: user_id, token: token)
        else
          conn
          |> redirect(to: page_path(conn, :index))
        end
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end

    with {:ok, %User{} = user} <- Stormchat.Users.get_and_auth_user(email, password) do
      token = Phoenix.Token.sign(conn, "auth token", user.id)
      conn
      |> put_status(:created)
      |> render("token.json", user: user, token: token)
    end

  end
end
