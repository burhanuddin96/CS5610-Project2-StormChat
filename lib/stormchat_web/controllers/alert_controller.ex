defmodule StormchatWeb.AlertController do
  use StormchatWeb, :controller

  alias Stormchat.Alerts

  action_fallback StormchatWeb.FallbackController

  # returns a list of a certain umber of the verified user's alerts by type
  # valid types...
  # active: the latest chunk of active alerts for the verified user
  # active_older: an older chunk of active alerts for the verified user
  # historical: the latest chunk of historical alerts for the verified user
  # historical_older: an older chunk of historical alerts for the verified user
  # for older, alert_id should be the oldest current alert
  def index(conn, params) do
    case Phoenix.Token.verify(conn, "auth token", params["token"], max_age: 86400) do
      {:ok, user_id} ->
        type = params["type"]

        alerts =
          case type do
            "active_by_location" -> Alerts.get_active_by_location(user_id, params["location_id"])
            "active_older_by_location" -> Alerts.get_older_active_by_location(user_id, params["location_id"], params["alert_id"])
            "historical_by_location" -> Alerts.get_historical_by_location(user_id, params["location_id"])
            "historical_older_by_location" -> Alerts.get_older_historical_by_location(user_id, params["location_id"], params["alert_id"])
            "active_by_latlong" -> Alerts.get_active_by_latlong(params["lat"], params["long"])
            "active_older_by_latlong" -> Alerts.get_older_active_by_latlong(params["lat"], params["long"], params["alert_id"])
            "historical_by_latlong" -> Alerts.get_historical_by_latlong(params["lat"], params["long"])
            "historical_older_by_latlong" -> Alerts.get_older_historical_by_latlong(params["lat"], params["long"], params["alert_id"])
            _else -> Alerts.list_alerts_by_user_id(user_id)
          end

        render(conn, "index.json", alerts: alerts)
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  # def create(conn, %{"alert" => alert_params}) do
  #   with {:ok, %Alert{} = alert} <- Alerts.create_alert(alert_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", alert_path(conn, :show, alert))
  #     |> render("show.json", alert: alert)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   alert = Alerts.get_alert!(id)
  #   render(conn, "show.json", alert: alert)
  # end

  # def update(conn, %{"id" => id, "alert" => alert_params}) do
  #   alert = Alerts.get_alert!(id)
  #
  #   with {:ok, %Alert{} = alert} <- Alerts.update_alert(alert, alert_params) do
  #     render(conn, "show.json", alert: alert)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   alert = Alerts.get_alert!(id)
  #   with {:ok, %Alert{}} <- Alerts.delete_alert(alert) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
