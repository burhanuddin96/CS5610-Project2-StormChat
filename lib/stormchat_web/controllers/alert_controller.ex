defmodule StormchatWeb.AlertController do
  use StormchatWeb, :controller

  alias Stormchat.Alerts
  alias Stormchat.Alerts.Alert

  action_fallback StormchatWeb.FallbackController

  # returns a list of the verified user's alerts
  def index(conn, _params) do
    case Phoenix.Token.verify(conn, "auth token", conn.assigns[:token], max_age: 86400) do
      {:ok, user_id} ->
        alerts = Alerts.list_alerts_by_user_id(user_id)
        render(conn, "index.json", alerts: alerts)
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  # returns a list of the verified user's active alerts
  def active(conn, _params) do
    case Phoenix.Token.verify(conn, "auth token", conn.assigns[:token], max_age: 86400) do
      {:ok, user_id} ->
        alerts = Alerts.get_active_alerts(user_id)
        render(conn, "index.json", alerts: alerts)
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  # returns a list of the verified user's historical alerts
  def historical(conn, _params) do
    case Phoenix.Token.verify(conn, "auth token", conn.assigns[:token], max_age: 86400) do
      {:ok, user_id} ->
        alerts = Alerts.get_historical_alerts(user_id)
        render(conn, "index.json", alerts: alerts)
      _else ->
        conn
        |> redirect(to: page_path(conn, :index))
    end
  end

  # TODO: determine if this will be needed
  def create(conn, %{"alert" => alert_params}) do
    with {:ok, %Alert{} = alert} <- Alerts.create_alert(alert_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", alert_path(conn, :show, alert))
      |> render("show.json", alert: alert)
    end
  end

  # TODO: determine if this will be needed
  def show(conn, %{"id" => id}) do
    alert = Alerts.get_alert!(id)
    render(conn, "show.json", alert: alert)
  end

  # TODO: determine if this will be needed
  def update(conn, %{"id" => id, "alert" => alert_params}) do
    alert = Alerts.get_alert!(id)

    with {:ok, %Alert{} = alert} <- Alerts.update_alert(alert, alert_params) do
      render(conn, "show.json", alert: alert)
    end
  end

  # TODO: determine if this will be needed
  def delete(conn, %{"id" => id}) do
    alert = Alerts.get_alert!(id)
    with {:ok, %Alert{}} <- Alerts.delete_alert(alert) do
      send_resp(conn, :no_content, "")
    end
  end
end
