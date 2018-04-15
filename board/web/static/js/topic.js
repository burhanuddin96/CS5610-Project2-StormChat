export class TopicChannel {
  constructor(channelId, eventHandler) {
   this.channelId = channelId
   this.eventHandler = eventHandler
  }
  join(socket) {
    this.channel = socket.channel(this.channelId, {})
    this.channel.on("new_post", resp => { this.eventHandler.onNewPost(resp) })
    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
  }
}

export class TopicShowPage {
  constructor(elem) {
    this.elem = elem;
    this.topicId = elem.dataset['topicId']
    this.channelId = elem.dataset['channelId']
  }
  static find(document) {
    const topicShowElem = document.getElementById('topic-show')
    return topicShowElem ? new TopicShowPage(topicShowElem) : null;
  }
  onNewPost({html}) {this.elem.insertAdjacentHTML('beforeend', html)}
}



