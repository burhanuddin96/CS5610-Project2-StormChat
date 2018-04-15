defmodule Board.RegistrationController do
  use Board.Web, :controller
  alias Board.User

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, _user} -> conn
                      |> put_flash(:info, "User created successfully.")
                      |> redirect(to: page_path(conn, :index))
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end

  def new(conn, _params) do
    changeset = User.registration_changeset(%User{})
    render conn, "new.html", changeset: changeset
  end
end
