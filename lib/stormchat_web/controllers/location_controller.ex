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

  def create(conn, %{"location" => location_params}) do
    with {:ok, %Location{} = location} <- Locations.create_location(location_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", location_path(conn, :show, location))
      |> render("show.json", location: location)
    end
  end

  def show(conn, %{"id" => id}) do
    location = Locations.get_location!(id)
    render(conn, "show.json", location: location)
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = Locations.get_location!(id)

    with {:ok, %Location{} = location} <- Locations.update_location(location, location_params) do
      render(conn, "show.json", location: location)
    end
  end

  def delete(conn, %{"id" => id}) do
    location = Locations.get_location!(id)
    with {:ok, %Location{}} <- Locations.delete_location(location) do
      send_resp(conn, :no_content, "")
    end
  end
end
