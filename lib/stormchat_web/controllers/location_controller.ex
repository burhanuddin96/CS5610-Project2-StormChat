defmodule StormchatWeb.LocationController do
  use StormchatWeb, :controller

  alias Stormchat.Locations
  alias Stormchat.Locations.Location

  action_fallback StormchatWeb.FallbackController

  # returns a list of the verified user's saved locations
  def index(conn, %{"token" => token}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        locations = Locations.list_locations_by_user_id(user_id)
        render(conn, "index.json", locations: locations)
      _else ->
        conn
        |> render(conn, %{error: "TOKEN_UNAUTHORIZED"})
    end
  end

  # creates a saved location for the verified user
  def create(conn, %{"location" => location_params, "token" => token}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        location_params = Map.put(location_params, "user_id", user_id)

        with {:ok, %Location{} = location} <- Locations.create_location(location_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", location_path(conn, :show, location))
          |> render("show.json", location: location)
        end
      _else ->
        conn
        |> render(conn, %{error: "TOKEN_UNAUTHORIZED"})
    end
  end

  # shows the location corresponding to the given location id
  # if and only if that locations user_id matches the verified user_id
  def show(conn, %{"id" => id, "token" => token}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        location = Locations.get_location(id)

        if location == nil || user_id != location.user_id do
          IO.inspect({:bad_match, location.user_id, user_id})
          raise "hax!"
        end

        render(conn, "show.json", location: location)
      _else ->
        conn
        |> render(conn, %{error: "TOKEN_UNAUTHORIZED"})
    end
  end

  # creates a saved location for the verified user
  def update(conn, %{"id" => id, "location" => location_params, "token" => token}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        location = Locations.get_location(id)

        if location == nil || user_id != location.user_id do
          IO.inspect({:bad_match, location.user_id, user_id})
          raise "hax!"
        end

        with {:ok, %Location{} = location} <- Locations.update_location(location, location_params) do
          render(conn, "show.json", location: location)
        end
      _else ->
        conn
        |> render(conn, %{error: "TOKEN_UNAUTHORIZED"})
    end
  end

  # deletes a verified user's saved location
  def delete(conn, %{"id" => id, "token" => token}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        location = Locations.get_location(id)

        if location == nil || user_id != location.user_id do
          IO.inspect({:bad_match, location.user_id, user_id})
          raise "hax!"
        end

        with {:ok, %Location{}} <- Locations.delete_location(location) do
          send_resp(conn, :no_content, "")
        end
      _else ->
        conn
        |> render(conn, %{error: "TOKEN_UNAUTHORIZED"})
    end
  end
end
