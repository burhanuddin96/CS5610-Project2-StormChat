defmodule Board.TopicController do
  use Board.Web, :controller
  plug :require_login when not action in [:index, :show]
  alias Board.Post
  alias Board.Topic
  
  def index(conn, _params) do
    topics = Repo.all(from x in Topic, join: y in assoc(x, :author), order_by: x.inserted_at, preload: [author: y])
    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = conn.assigns.current_user
                |> build_assoc(:topics)
                |> Topic.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    changeset = conn.assigns.current_user
                |> build_assoc(:topics)
                |> Topic.changeset(topic_params)
    case Repo.insert(changeset) do
      {:ok, _topic} -> conn
                       |> put_flash(:info, "Topic created successfully.")
                       |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Repo.get!(Topic, id) |> Repo.preload([:author])
    posts = Repo.all(from x in assoc(topic, :posts), join: y in assoc(x, :author), order_by: x.inserted_at, preload: [author: y])
    post_changeset = topic
                     |> build_assoc(:posts)
                     |> Post.changeset()
    render(conn, "show.html", topic: topic, posts: posts, post_changeset: post_changeset)
  end

  def edit(conn, %{"id" => id}) do
    topic = Repo.get!(Topic, id)
    changeset = Topic.changeset(topic)
    render(conn, "edit.html", topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Repo.get!(Topic, id)
    changeset = Topic.changeset(topic, topic_params)
    case Repo.update(changeset) do
      {:ok, topic} -> conn
                      |> put_flash(:info, "Topic updated successfully.")
                      |> redirect(to: topic_path(conn, :show, topic))
      {:error, changeset} -> render(conn, "edit.html", topic: topic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Repo.get!(Topic, id)
    Repo.delete!(topic)
    conn
    |> put_flash(:info, "Topic deleted successfully.")
    |> redirect(to: topic_path(conn, :index))
  end
end
