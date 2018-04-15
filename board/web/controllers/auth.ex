defmodule Board.Auth do
  import Plug.Conn
  alias Phoenix.Controller
  alias Comeonin.Bcrypt
  alias Board.Router.Helpers

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def enter_email_psswd(conn, email, password) do
    user = Board.Repo.get_by(Board.User, email: email)
    cond do
      user && Bcrypt.checkpw(password, user.password_hash) -> {:ok, login(conn, user)}
      user -> {:error, :wrong_password, conn}
      true -> Bcrypt.dummy_checkpw()
              {:error, :not_found, conn}
    end
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    cond do
      user = conn.assigns[:current_user] -> present_user(conn, user)
      user = user_id && repo.get(Board.User, user_id) -> present_user(conn, user)
      true -> assign(conn, :current_user, nil)
    end
  end

  def logout(conn) do
    clear_session(conn)
  end

  def login(conn, user) do
    conn
    |> present_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  defp present_user(conn, user) do
    conn
    |> assign(:current_user, user)
  end

  def require_login(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> Controller.put_flash(:info, "Please log in")
      |> Controller.redirect(to: Helpers.session_path(conn, :new))
      |> halt()
    end
  end
end
