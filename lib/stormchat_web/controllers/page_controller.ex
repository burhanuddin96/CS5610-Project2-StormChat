defmodule StormchatWeb.PageController do
  use StormchatWeb, :controller

  # render main log-in page, passing along alert_id for future redirect if relevant
  def index(conn, params) do
    render conn, "index.html", alert_id: params["alert_id"]
  end

  # if a user is logged in, render the home page
  # otherwise redirect to the log-in page (see index above)
  def home(conn, _params) do
    case Phoenix.Token.verify(conn, "auth token", conn.assigns[:token], max_age: 86400) do
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
  def alert(conn, params) do
    case Phoenix.Token.verify(conn, "auth token", conn.assigns[:token], max_age: 86400) do
      {:ok, user_id} ->
        user = Stormchat.Users.get_user(user_id)
        if user do
          render conn, "alert.html", alert_id: params["alert_id"]
        else
          conn
          |> redirect(to: page_path(conn, :index))
        end
      _no_valid_token ->
        conn
        |> redirect(to: page_path(conn, :index, params["alert_id"]))
    end
  end
end
