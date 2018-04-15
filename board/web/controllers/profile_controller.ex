defmodule Board.ProfileController do
  use Board.Web, :controller
  plug :require_login

  def show(conn, _params) do
    render conn, "show.html", profile: conn.assigns.current_user
  end
end
