import "phoenix_html"
import { TopicShowPage, TopicChannel } from "./topic"
import { Socket } from "phoenix"

const socket = new Socket("/socket")
socket.connect()

const topicShow = TopicShowPage.find(document)
if (topicShow) {
  const topicChannel = new TopicChannel(topicShow.channelId, topicShow)
  topicChannel.join(socket)
}
