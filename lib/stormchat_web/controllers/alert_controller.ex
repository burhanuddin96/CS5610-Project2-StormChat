defmodule StormchatWeb.AlertController do
  use StormchatWeb, :controller

  alias Stormchat.Alerts
  alias Stormchat.Alerts.Alert

  action_fallback StormchatWeb.FallbackController

  # returns a list of the verified user's alerts
  def index(conn, _params) do
    token = assigns(conn, :token)

    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        alerts = Alerts.list_alerts_by_user_id(user_id)
        render(conn, "index.json", alerts: alerts)
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  def create(conn, %{"alert" => alert_params}) do
    with {:ok, %Alert{} = alert} <- Alerts.create_alert(alert_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", alert_path(conn, :show, alert))
      |> render("show.json", alert: alert)
    end
  end

  def show(conn, %{"id" => id}) do
    alert = Alerts.get_alert!(id)
    render(conn, "show.json", alert: alert)
  end

  def update(conn, %{"id" => id, "alert" => alert_params}) do
    alert = Alerts.get_alert!(id)

    with {:ok, %Alert{} = alert} <- Alerts.update_alert(alert, alert_params) do
      render(conn, "show.json", alert: alert)
    end
  end

  def delete(conn, %{"id" => id}) do
    alert = Alerts.get_alert!(id)
    with {:ok, %Alert{}} <- Alerts.delete_alert(alert) do
      send_resp(conn, :no_content, "")
    end
  end
end
