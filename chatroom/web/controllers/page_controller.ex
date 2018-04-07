defmodule Faster.PageController do
  alias Faster.Session
  use Faster.Web, :controller
  
  def index(conn, _params) do
    if Session.logged_in?(conn) do
      render conn, "logged.html", user: Session.current_user(conn)
    else
      render conn, "not_logged.html"
    end
  end
end
