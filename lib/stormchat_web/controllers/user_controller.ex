defmodule StormchatWeb.UserController do
  use StormchatWeb, :controller

  alias Stormchat.Users
  alias Stormchat.Users.User
  alias Stormchat.Locations

  action_fallback StormchatWeb.FallbackController

  # def index(conn, _params) do
  #   users = Users.list_users()
  #   render(conn, "index.json", users: users)
  # end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  # returns the appropriate user view based on who's requesting
  def show(conn, %{"id" => id, "token" => token}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        user = Users.get_user!(id)

        if user_id == id do
          render(conn, "show.json", user: user)
        else
          render(conn, "show_restricted.json", user: user)
        end
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  # verifies that the token user matches the user to be updated, then updates
  def update(conn, %{"id" => id, "user_params" => user_params, "token" => token}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        user = Users.get_user(id)

        if user == nil || id != user_id do
          IO.inspect({:bad_match, id, user_id})
          raise "hax!"
        end

        with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
          render(conn, "show.json", user: user)
        end
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  # verifies that the token user matches the user to be deleted, then deletes
  def delete(conn, %{"id" => id, "token" => token}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        user = Users.get_user!(id)

        if user == nil || id != user_id do
          IO.inspect({:bad_match, id, user_id})
          raise "hax!"
        end

        with {:ok, %User{}} <- Users.delete_user(user) do
          send_resp(conn, :no_content, "")
        end
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end
end
