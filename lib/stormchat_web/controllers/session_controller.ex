defmodule StormchatWeb.SessionController do
  use StormchatWeb, :controller

  alias Stormchat.Users

  # creates a session for the given user credentials if authorized
  # and puts the token in the conn assigns
  def create(conn, %{"email" => email, "password" => password}) do
    case Stormchat.Users.get_and_auth_user(email, password) do
      {:ok, %User{} = user} ->
        token = Phoenix.Token.sign(conn, "auth token", user.id)

        conn
        |> assign(:token, token)
        |> put_flash(:info, "Welcome back, #{user.name}!")
        |> redirect(to: page_path(conn, :home))

      _else ->
        conn
        |> put_flash(:error, "Invalid credentials!")
        |> redirect(to: page_path(conn, :index))
    end
  end

  # closes the given connection's session
  # and removes the token from the conn assigns
  def delete(conn, _params) do
    conn
    |> Map.put(:assigns, Map.delete(conn.assigns, :token))
    |> put_flash(:info, "Logged out!")
    |> redirect(to: page_path(conn, :index))
  end
end
