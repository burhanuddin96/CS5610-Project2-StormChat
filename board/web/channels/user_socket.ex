defmodule Board.UserSocket do
  use Phoenix.Socket
  transport :websocket, Phoenix.Transports.WebSocket
  channel "topic:*", Board.TopicChannel
  transport :longpoll, Phoenix.Transports.LongPoll
  
  def id(_socket) do
    nil
  end

  def connect(_params, socket) do
    {:ok, socket}
  end
end
