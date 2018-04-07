defmodule Faster.Session do
  alias Faster.{Repo, User}
  use Faster.Web, :model

  def current_user(connection) do
    id = Plug.Conn.get_session(connection, :current_user)
    if id, do: Repo.get(User, id)
  end

  def logged_in?(connection), do: !!current_user(connection)
end
