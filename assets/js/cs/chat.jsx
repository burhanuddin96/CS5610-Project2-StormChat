import React from 'react';
import { connect } from 'react-redux';
import { Button } from 'reactstrap';
import Spinner from './spinner';
import HomeMap from './homemap';
import api from '../api';

class Home extends React.Component {

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

  }

  gotError(error) {
    store.dispatch({
      type: 'ERROR_MSG',
      msg: error.reason
    });
  }

  toggleDetail() { this.setState({detail: !this.state.detail}); }

  render() {
    return (
      <div>
        <div className="bg-info text-white rounded m-3 p-3">
          <div className="row">
            <h2 className="col">Local Weather</h2>
          </div>
          {this.renderWeather()}
        </div>
        <div className="m-3">
          <div className="row">
            <div className="col-7">
              <HomeMap />
            </div>
            <div className="col-5">
              <div className="border border-info rounded ml-3 p-3">
                <h2 className="d-inline-block">Alerts by Locations</h2>
                <Button color="info" className="float-right"
                        onClick={this.toggleEdit.bind(this)}>
                  {this.state.editing ? "Done" : "Edit"}
                </Button>
                {this.renderForm()}
                {this.renderLocations()}
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

function Message(params) {
  let classes = "border";
  if (params.mine) {
    classes += "border-info my-message";
  } else {
    classes += "border-secondary other-message";
  }

  return (
    <div className={classes}>
      <h6>params.</h6>
      <br/>
      <small>{params.message}</small>
    </div>
  );
}

export default connect((state) => state)(Home);
