defmodule Faster.SessionController do
  alias Faster.User
  use Faster.Web, :controller


  def new(conn, _params) do
    render conn, "new.html"
  end

  def delete(conn, _params) do
    conn
      |> delete_session(:current_user)
      |> put_flash(:info, "Logged out")
      |> redirect(to: "/")
  end

  def create(conn, %{"login" => login_params}) do
    login_params
    |> User.authenticate
    |> login(conn)
  end

  defp login(user, conn) do
    conn
      |> put_session(:current_user, user.id)
      |> put_flash(:info, "LogIn Successful!")
      |> redirect(to: "/")
  end

  defp login(nil, conn) do
    conn
    |> put_flash(:info, "Username and password does not match")
    |> redirect(to: session_path(conn, :create))
  end
end
