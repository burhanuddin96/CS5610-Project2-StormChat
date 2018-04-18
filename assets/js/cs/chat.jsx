import React from 'react';
import { connect } from 'react-redux';
import { Button, Input } from 'reactstrap';
import { Socket } from 'phoenix';
import Spinner from './spinner';
import HomeMap from './homemap';
import api from '../api';

class Chat extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      detail: false,
      alert: {},
      polygons: [],
      user_count: 0,
      posts: []
    };
    this.socket = new Socket("/socket", {params: {token: this.props.user.token}});
    this.socket.connect();
    this.channel = this.socket.channel("alerts:" + this.props.alert_id, {});
    this.channel.on("new_post", this.newMessage.bind(this));
    this.channel.join()
      .receive("ok", this.gotAlert.bind(this))
      .receive("error", this.gotError.bind(this));
  }

  componentWillUnmount() {
    this.channel.leave();
    this.channel = null;
    this.socket = null;
  }

  gotAlert(alertInfo) {
    console.log("ALERT", alertInfo);
    this.setState(alertInfo);
  }

  gotError(error) {
    this.props.dispatch({
      type: 'ERROR_MSG',
      msg: error.reason
    });
  }

  newMessage(msg) { this.setState({posts: this.state.posts.concat(msg.post)}); }

  toggleDetail() { this.setState({detail: !this.state.detail}); }

  sendMessage() {
    let input = $('#chat-field')[0];
    input = $(input).val();
    this.channel.push('post', {'body': input})
      .receive("error", this.gotError.bind(this));
  }

  render() {
    let messages = _.map(this.state.posts, (post) => {
      return <Message key={post.id}
                      message={post.body}
                      user={post.user}
                      mine={post.user.id == this.props.user.user_id}/>;
    });

    return (
      <div id="chat" className="container">
        <div id="chat-messages">
          {messages}
        </div>
        <div id="chat-footer" className="row">
          <Input name="chat-field"
                 type="text"
                 id="chat-field"
                 placeholder="Send a message..."
                 className="mx-3 col" />
          <Button onClick={this.sendMessage.bind(this)}
                  color="info" className="mr-3">
            Send
          </Button>
        </div>
      </div>
    );
  }
}

function Message(params) {
  let classes = "border row";
  if (params.mine) {
    classes += "border-info text-info my-message";
  } else {
    classes += "border-secondary text-secondary other-message";
  }

  return (
    <div className={classes}>
      <h6>{params.user.name}</h6>
      <br/>
      <small>{params.message}</small>
    </div>
  );
}

export default connect((state) => state)(Chat);
