defmodule StormchatWeb.CountyController do
  use StormchatWeb, :controller

  alias Stormchat.Alerts
  alias Stormchat.Alerts.County

  action_fallback StormchatWeb.FallbackController

  # TODO: determine if any of these are really needed

  def index(conn, _params) do
    counties = Alerts.list_counties()
    render(conn, "index.json", counties: counties)
  end

  def create(conn, %{"county" => county_params}) do
    with {:ok, %County{} = county} <- Alerts.create_county(county_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", county_path(conn, :show, county))
      |> render("show.json", county: county)
    end
  end

  def show(conn, %{"id" => id}) do
    county = Alerts.get_county!(id)
    render(conn, "show.json", county: county)
  end

  def update(conn, %{"id" => id, "county" => county_params}) do
    county = Alerts.get_county!(id)

    with {:ok, %County{} = county} <- Alerts.update_county(county, county_params) do
      render(conn, "show.json", county: county)
    end
  end

  def delete(conn, %{"id" => id}) do
    county = Alerts.get_county!(id)
    with {:ok, %County{}} <- Alerts.delete_county(county) do
      send_resp(conn, :no_content, "")
    end
  end
end
