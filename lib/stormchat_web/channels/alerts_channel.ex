defmodule StormchatWeb.AlertsChannel do
  use StormchatWeb, :channel

  def join("alerts:" <> alert_id, payload, socket) do
    alert = Stormchat.Alerts.get_alert(alert_id)

    if alert == nil do
      {:error, %{reason: "no such alert"}}
    else
      {:ok, %{"alert" => alert}, socket}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (alerts:alert_id).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
