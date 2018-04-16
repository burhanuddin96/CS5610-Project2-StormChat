defmodule StormchatWeb.PageController do
  use StormchatWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  # if a user is logged in, render the home page
  # otherwise redirect to the log-in page (see index above)
  def home(conn, _params) do
    token = assigns(conn, :token)

    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        user = Stormchat.Users.get_user(user_id)

        if user do
          render conn, "home.html"
        else
          conn
          |> redirect(to: page_path(conn, :index))
        end
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  # if a user is logged in, render the alert page
  # otherwise redirect to the log-in page (see index above)
  def alert(conn, _params) do
    token = assign(conn, :token)

    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        user = Stormchat.Users.get_user(user_id)
        if user do
          render conn, "alert.html", alert: params["alert"]
        else
          conn
          |> redirect(to: page_path(conn, :index))
        end
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end
end
