defmodule Board.TopicChannel do
  use Board.Web, :channel

  def join("topic:" <> topic_id, _params, socket) do
    {:ok, assign(socket, :topic_id, topic_id)}
  end  

  def id(topic) do
    "topic:#{topic.id}"
  end
end
