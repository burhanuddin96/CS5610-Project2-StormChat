defmodule StormchatWeb.UserController do
  use StormchatWeb, :controller

  alias Stormchat.Users
  alias Stormchat.Users.User

  action_fallback StormchatWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  # returns the verified user (view doesn't include password_hash)
  def show(conn, %{"id" => id}) do
    case Phoenix.Token.verify(conn, "auth token", conn.assigns[:token], max_age: 86400) do
      {:ok, user_id} ->
        user = Users.get_user!(user_id)
        render(conn, "show.json", user: user)
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  # verifies that the token user matches the user to be updated
  # TODO: finish this!!!
  def update(conn, %{"token" => token, "user_params" => user_params}) do
    {:ok, user_id} = Phoenix.Token.verify(conn, "auth token", token, max_age: 86400)
    user = Users.get_user(user_id)

    if user == nil || user.id != user_params["id"] do
      IO.inspect({:bad_match, user_params["id"], user.id})
      raise "hax!"
    end

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
