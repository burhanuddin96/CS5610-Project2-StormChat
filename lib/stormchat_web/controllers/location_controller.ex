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
        #|> redirect(to: page_path(conn, :index))
    end
  end

  # creates a saved location for the verified user
  def create(conn, %{"location" => location_params, "token" => token}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        if user_id != location_params["user_id"] do
          IO.inspect({:bad_match, location_params["user_id"], user_id})
          raise "hax!"
        end

        with {:ok, %Location{} = location} <- Locations.create_location(location_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", location_path(conn, :show, location))
          |> render("show.json", location: location)
        end
      _else ->
        conn
        #|> redirect(to: page_path(conn, :index))
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
        #|> redirect(to: page_path(conn, :index))
    end
  end
end
