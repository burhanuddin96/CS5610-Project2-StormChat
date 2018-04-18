defmodule StormchatWeb.PostController do
  use StormchatWeb, :controller

  # alias Stormchat.Posts
  # alias Stormchat.Posts.Post

  action_fallback StormchatWeb.FallbackController

  # # returns a list of a certain number of the given alert's posts by type
  # # valid types...
  # # latest: the latest chunk of posts for the given alert
  # # older: an older chunk of posts for the given alert
  # # for older, post_id should be the oldest current post
  # def index(conn, %{"token" => token, "type" => type, "alert_id" => alert_id, "post_id" => post_id}) do
  #   case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
  #     {:ok, _user_id} ->
  #       posts =
  #         case type do
  #           "latest" -> Posts.get_latest_posts(alert_id)
  #           "older" -> Posts.get_older_posts(post_id)
  #           _else -> Posts.get_latest_posts(alert_id)
  #         end
  #
  #       render(conn, "index.json", posts: posts)
  #     _else ->
  #       conn
  #       |> redirect(to: page_path(conn, :index))
  #   end
  # end
  #
  # def create(conn, %{"post" => post_params, "token" => token}) do
  #   case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
  #     {:ok, user_id} ->
  #       user = Users.get_user(id)
  #
  #       if user == nil || post_params["user_id"] != user_id do
  #         IO.inspect({:bad_match, post_params["user_id"], user_id})
  #         raise "hax!"
  #       end
  #
  #       with {:ok, %Post{} = post} <- Posts.create_post(post_params) do
  #         conn
  #         |> put_status(:created)
  #         |> put_resp_header("location", post_path(conn, :show, post))
  #         |> render("show.json", post: post)
  #       end
  #     _else ->
  #       conn
  #       |> redirect(to: page_path(conn, :index))
  #   end
  # end
  #
  # def show(conn, %{"id" => id}) do
  #   post = Posts.get_post!(id)
  #   render(conn, "show.json", post: post)
  # end
  #
  # def update(conn, %{"id" => id, "post" => post_params}) do
  #   post = Posts.get_post!(id)
  #
  #   with {:ok, %Post{} = post} <- Posts.update_post(post, post_params) do
  #     render(conn, "show.json", post: post)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   post = Posts.get_post!(id)
  #   with {:ok, %Post{}} <- Posts.delete_post(post) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
