defmodule Stormchat.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Stormchat.Repo

  alias Stormchat.Posts.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  def post_limit do
    10
  end

  # returns a list of the latest "post_limit" posts
  def get_latest_posts(alert_id) do
    pl = post_limit()

    query =
      from p in Post,
        where: p.alert_id == ^alert_id,
        select: p,
        order_by: [desc: p.inserted_at],
        limit: ^pl

    Repo.all(query)
  end

  # returns a list of the previous "post_limit" posts, including the given post
  def get_previous_posts(first_id) do
    first_post = get_post(first_id)
    alert_id = first_post.alert_id
    inserted_at = first_post.inserted_at
    pl = post_limit()

    query =
      from p in Post,
        where: p.alert_id == ^alert_id and p.inserted_at <= ^inserted_at,
        select: p,
        order_by: [desc: p.inserted_at],
        limit: ^pl

    Repo.all(query)
  end

  # returns a list of the next "post_limit" posts, including the given post
  def get_next_posts(last_id) do
    last_post = get_post(last_id)
    alert_id = last_post.alert_id
    inserted_at = last_post.inserted_at
    pl = post_limit()

    query =
      from p in Post,
        where: p.alert_id == ^alert_id and p.inserted_at >= ^inserted_at,
        select: p,
        order_by: [desc: p.inserted_at],
        limit: ^pl

    Repo.all(query)
  end

  def list_posts_by_alert_id(alert_id) do
    query =
      from p in Post,
      where: p.alert_id == ^alert_id

    Repo.all(query)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  def get_post(id), do: Repo.get(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end
end
