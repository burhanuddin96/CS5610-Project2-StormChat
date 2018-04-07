defmodule Faster.UserController do
  alias Faster.{User,Repo}
  use Faster.Web, :controller

  def create(conn, %{"user" => user_params}) do
      User.changeset(%User{}, user_params)
      |> User.hash_password()
      |> Repo.insert()
      |> case do
           {:ok, user} -> conn
                          |> put_session(:current_user, user.id)
                          |> put_flash(:info, "Your account was created!")
                          |> redirect(to: "/")
           {:error, changeset} -> conn
                                  |> put_flash(:warning, "Unable to create account")
                                  |> render("new.html", changeset: changeset)    
      end
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end
end
