defmodule Board.PageController do
  use Board.Web, :controller
  alias Board.Topic

  def index(conn, _params) do
    recent = Repo.all(from x in Topic, join: y in assoc(x, :author), order_by: [desc: x.inserted_at], preload: [author: y], limit: 5)
    render conn, "index.html", %{recent: recent}
  end
end
