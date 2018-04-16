defmodule StormchatWeb.AlertsChannel do
  use StormchatWeb, :channel

  alias Stormchat.Locations
  alias Stormchat.Posts

  # authenticates socket tocken, then returns the following payload
  # - alert: the alert for this channel
  # - polygons: a list of the polygons affected by this channel's alert
  # - post: a list of the latest posts for this channel's alert
  # - users: a list of users with saved locations affected by this channel's alert
  def join("alerts:" <> alert_id, payload, socket) do
    case Phoenix.Token.verify(conn, "auth token", socket.assigns[:token], max_age: 86400) do
      {:ok, user_id} ->
        alert = Stormchat.Alerts.get_alert(alert_id)

        if alert == nil do
          {:error, %{reason: "no such alert"}}
        else
          polygons = Locations.get_affected_polygons(alert.id)
          posts = Posts.get_latest_posts(alert.id)
          users = Users.get_affected_users(alert.id)

          {:ok, %{"alert" => alert, "polygons" => polygons, "posts" => posts, "users" => users}, socket}
        end
      _else ->
      {:error, %{reason: "invalid authorization token"}}
    end
  end

  # sent when a new post is to be created, returns a list of this channel's latest posts
  def handle_in("post", attrs, socket) do
    case Phoenix.Token.verify(conn, "auth token", socket.assigns[:token], max_age: 86400) do
      {:ok, _user_id} ->
        {msg, resp} = Posts.create_post(attrs)

        case msg do
          ok: ->
            payload = %{"posts" => Posts.get_latest_posts(attrs[:alert_id])}
            broadcast_from socket, "new_post", payload
            {:reply, {:ok, payload}, socket}
          _error ->
            {:reply, {:error, %{reason: "error creating post"}}
        end
      _else ->
        {:error, %{reason: "invalid authorization token"}}
    end
  end

  # returns the given post plus the posts_limit - 1 previous posts
  def handle_in("previous",  %{"first_id" => first_id}, socket) do
    case Phoenix.Token.verify(conn, "auth token", socket.assigns[:token], max_age: 86400) do
      {:ok, _user_id} ->
        {:reply, {:ok, %{ "posts" => Posts.get_previous_posts(first_id)}}, socket}
      _else ->
        {:error, %{reason: "invalid authorization token"}}
    end
  end

  # returns the given post plus the posts_limit - 1 next posts
  def handle_in("next",  %{"last_id" => last_id}, socket) do
    case Phoenix.Token.verify(conn, "auth token", socket.assigns[:token], max_age: 86400) do
      {:ok, _user_id} ->
        {:reply, {:ok, %{ "posts" => Posts.get_next_posts(last_id)}}, socket}
      _else ->
        {:error, %{reason: "invalid authorization token"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (alerts:alert_id).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
