defmodule StormchatWeb.LocationCountyController do
  use StormchatWeb, :controller

  alias Stormchat.Locations
  alias Stormchat.Locations.LocationCounty

  action_fallback StormchatWeb.FallbackController

  # TODO: determine if any of these are needed

  def index(conn, _params) do
    location_counties = Locations.list_location_counties()
    render(conn, "index.json", location_counties: location_counties)
  end

  def create(conn, %{"location_county" => location_county_params}) do
    with {:ok, %LocationCounty{} = location_county} <- Locations.create_location_county(location_county_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", location_county_path(conn, :show, location_county))
      |> render("show.json", location_county: location_county)
    end
  end

  def show(conn, %{"id" => id}) do
    location_county = Locations.get_location_county!(id)
    render(conn, "show.json", location_county: location_county)
  end

  def update(conn, %{"id" => id, "location_county" => location_county_params}) do
    location_county = Locations.get_location_county!(id)

    with {:ok, %LocationCounty{} = location_county} <- Locations.update_location_county(location_county, location_county_params) do
      render(conn, "show.json", location_county: location_county)
    end
  end

  def delete(conn, %{"id" => id}) do
    location_county = Locations.get_location_county!(id)
    with {:ok, %LocationCounty{}} <- Locations.delete_location_county(location_county) do
      send_resp(conn, :no_content, "")
    end
  end
end
