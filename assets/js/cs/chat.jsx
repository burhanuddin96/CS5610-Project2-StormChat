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
    alertInfo.posts = alertInfo.posts.reverse();
    this.setState(alertInfo);
  }

  gotError(error) {
    this.props.dispatch({
      type: 'ERROR_MSG',
      msg: error.reason
    });
  }

  newMessage(msg) {
    console.log("NEW_MSG", msg);
    this.setState({posts: this.state.posts.concat(msg.post)});
  }

  toggleDetail() { this.setState({detail: !this.state.detail}); }

  sendMessage() {
    this.props.dispatch({type: 'RESET_ERROR'});
    let input = $('#chat-field')[0];
    input = $(input).val();
    this.channel.push('post', {'body': input})
      .receive("error", this.gotError.bind(this))
      .receive("ok", ((msg) => {
        console.log(msg);
        this.newMessage(msg);
        $($('#chat-field')[0]).val("");
      }).bind(this));
  }

  render() {
    let messages = _.map(this.state.posts, (post) => {
      return <Message key={post.id}
                      message={post.body}
                      user={post.user}
                      timestamp={post.timestamp}
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
  let color = params.mine ? "warning" : "info";
  let classes = `border border-${color} mb-3 text-secondary message`;
  if (params.mine) {
    classes += " my-message";
  }

  let timestamp = new Date(`${params.timestamp}Z`).toLocaleString();

  return (
    <div className="row">
      <div className="col">
        <div className={classes}>
          <p className="m-2">
            <strong className={`text-${color}`}>{params.user.name}</strong>
            <small className="float-right">{timestamp}</small>
            <br/>
            {params.message}
          </p>
        </div>
      </div>
    </div>
  );
}

export default connect((state) => state)(Chat);
