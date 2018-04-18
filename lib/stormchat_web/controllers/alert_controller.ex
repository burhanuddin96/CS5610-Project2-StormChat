defmodule StormchatWeb.AlertController do
  use StormchatWeb, :controller

  alias Stormchat.Alerts
  alias Stormchat.Alerts.Alert

  action_fallback StormchatWeb.FallbackController

  # returns a list of a certain number of the verified user's alerts by type
  # valid types...
  # active: the latest chunk of active alerts for the verified user
  # active_older: an older chunk of active alerts for the verified user
  # historical: the latest chunk of historical alerts for the verified user
  # historical_older: an older chunk of historical alerts for the verified user
  # for older, alert_id should be the oldest current alert
  def index(conn, %{"token" => token, "type" => type, "alert_id" => alert_id}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        alerts =
          case type do
            "active" -> Alerts.get_active_alerts(user_id)
            "active_older" -> Alerts.get_older_active_alerts(user_id, alert_id)
            "historical" -> Alerts.get_historical_alerts(user_id)
            "historical_older" -> Alerts.get_older_historical_alerts(user_id, alert_id)
            _else -> Alerts.get_active_alerts(user_id)
          end

        render(conn, "index.json", alerts: alerts)
      _else ->
        conn
        #|> redirect(to: page_path(conn, :index))
    end
  end
end
