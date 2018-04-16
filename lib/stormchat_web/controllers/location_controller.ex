defmodule StormchatWeb.LocationController do
  use StormchatWeb, :controller

  alias Stormchat.Locations
  alias Stormchat.Locations.Location

  action_fallback StormchatWeb.FallbackController

  # returns a list of the verified user's saved locations
  def index(conn, _params) do
    token = assigns(conn, :token)

    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        locations = Locations.list_locations_by_user_id(user_id)
        render(conn, "index.json", locations: locations)
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  # creates a saved location for the verified user
  def create(conn, %{"location" => location_params}) do
    token = assigns(conn, :token)

    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        # make sure a verified user can only create locations for themselves
        location_params = Map.put(location_params, :user_id, user_id)

        with {:ok, %Location{} = location} <- Locations.create_location(location_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", location_path(conn, :show, location))
          |> render("show.json", location: location)
        end
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    location = Locations.get_location!(id)
    render(conn, "show.json", location: location)
  end

  # creates a saved location for the verified user
  def update(conn, %{"id" => id, "location" => location_params}) do
    token = assigns(conn, :token)

    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        location = Locations.get_location!(id)

        # make sure the given location is the verified user's
        if location.user_id == user_id do
          with {:ok, %Location{} = location} <- Locations.update_location(location, location_params) do
            render(conn, "show.json", location: location)
          end
        else
          |> redirect(to: page_path(conn, :index))
        end
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  # deletes a verified user's saved location
  def delete(conn, %{"id" => id}) do
    token = assigns(conn, :token)

    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        location = Locations.get_location!(id)

        # make sure the given location is the verified user's
        if location.user_id == user_id do
          with {:ok, %Location{}} <- Locations.delete_location(location) do
            send_resp(conn, :no_content, "")
          end
        else
          |> redirect(to: page_path(conn, :index))
        end
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end
end
