defmodule Board.PostController do
  use Board.Web, :controller
  plug :require_login when not action in []
  alias Board.Topic
  alias Board.Post
  
  def create(conn, %{"topic_id" => topic_id, "post" => post_params}) do
    topic = Repo.get!(Topic, topic_id)
    user = conn.assigns.current_user
    changeset = %Post{author: user, topic: topic}
                |> Post.changeset(post_params)
    case Repo.insert(changeset) do
      {:ok, post} -> new_post_html = Phoenix.View.render_to_string(Board.ComponentView, "post_card.html", post: post)
                                     Board.Endpoint.broadcast! Board.TopicChannel.id(topic),"new_post", %{"html" => new_post_html}
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: topic_path(conn, :show, topic))
      {:error, changeset} -> render(conn, "new.html", changeset: changeset, topic: topic)
    end
  end
end
