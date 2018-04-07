import $ from "jquery"
import socket from "./socket"

const KEY = 13

class Chat {
    static init() {
        this.setupChannel()
        this.messages = $("#messages")
        this.username = $("#from_phoenix").attr("username")
        this.chatbox = $("#chatbox")
        this.chatbox.keypress(function (event) {
            let pressedKey = event.which
            if (pressedKey == KEY && Chat.chatboxContent() !== "") {
                Chat.channel.push('new_message', { user: Chat.username, content: Chat.chatboxContent() })
                Chat.chatbox.val("")
            }
        })
    }
    static chatboxContent() { return this.chatbox.val() }
    static setupChannel() {
        this.channel = socket.channel("lobby", { user: Chat.username })
        this.channel.join()
        this.channel.on("new_message", (payload) => { this.render(Chat.messageTemplate, [payload.user, payload.content]) })
        this.channel.on("join", (payload) => {
            let user = (payload.user == Chat.username)? "You": payload.user
            this.render(Chat.joinedTemplate, [user])
        })
    }
    static joinedTemplate(user) {
        this.messages.append(`<div><font color="grey"><b>${user}</b>
                                      joined the room</font></div>`)
    }
    static scrollDown() {
        this.messages.stop().animate(
            {scrollTop: this.messages[0].scrollHeight}, 800);
    }
    static sanitize(html) {
      return $("<div/>").text(html).html()
    }
    static messageTemplate(user, message) {
        this.messages.append(`<div><font><b>${user}: </b>
                                   <i>${message}</i></font></div>`)
    }
    static render(template, params) {
        let safe_params = params.map(this.sanitize)
        template.apply(Chat, safe_params)
        Chat.scrollDown()
    }
}

export default Chat
