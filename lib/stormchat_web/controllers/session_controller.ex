defmodule StormchatWeb.SessionController do
  use StormchatWeb, :controller

  alias Stormchat.Users
  alias Stormchat.Users.User

  # creates a session for the given user credentials if authorized
  # and puts the token in the conn assigns
  def create(conn, params) do

    email = params["email"]
    password = params["password"]

    case Stormchat.Users.get_and_auth_user(email, password) do
      {:ok, %User{} = user} ->
        token = Phoenix.Token.sign(conn, "auth token", user.id)

        if params["alert_id"] == nil || params["alert_id"] == "" do
          conn
          |> assign(:token, token)
          |> put_flash(:info, "Welcome back, #{user.name}!")
          |> redirect(to: page_path(conn, :home))
        else
          conn
          |> assign(:token, token)
          |> redirect(to: page_path(conn, :alert, params["alert_id"]))
        end
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
