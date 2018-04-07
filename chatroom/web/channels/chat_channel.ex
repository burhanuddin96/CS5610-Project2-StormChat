defmodule Faster.ChatChannel do
  alias Faster.Message
  use Faster.Web, :channel

  def handle_info({:after_join, payload}, socket) do
   broadcast! socket, "join", payload
   {:noreply, socket}
 end

  def join("lobby", payload, socket) do
     send self(), {:after_join, payload}
     {:ok, socket}
  end

  def handle_in("new_message", payload, socket) do
    Message.create(payload)
    broadcast! socket, "new_message", payload
    {:noreply, socket}
  end
end
