defmodule Board.SessionController do
  use Board.Web, :controller

  def create(conn, %{"credentials" => %{"email" => email, "password" => password}}) do
    case Board.Auth.enter_email_psswd(conn, email, password) do
      {:ok, conn} -> conn
                     |> put_flash(:info, "Welcome back!")
                     |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} -> conn
                                 |> put_flash(:error, "Wrong password or email.")
                                 |> render("new.html")
    end
  end

  def new(conn, _) do
    render(conn, "new.html")
  end

  def delete(conn, _) do
    conn
    |> Board.Auth.logout()
    |> put_flash(:info, "Successfully logged out")
    |> redirect(to: page_path(conn, :index))
  end
end
