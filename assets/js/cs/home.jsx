import React from 'react';
import { connect } from 'react-redux';
import Spinner from './spinner';

function titleCase(str) {
  return str.toLowerCase()
    .split(' ')
    .map((word) => {
      return word.charAt(0).toUpperCase() + word.slice(1);
    })
    .join(' ');
}

class Home extends React.Component {

  constructor(props) {
    super(props);
    this.state = {editing: false};
  }

  render() {
    return (
      <div>
        <div className="row">
          <h2>Local Weather</h2>
          {this.renderWeather()}
        </div>
        <div className="row">
          <div className="col-8">
            MAP HERE
          </div>
          <div className="col-4">
            <div>
              <h2>Saved Locations</h2>
              <Button color="primary"
                      className="float-right">
                Edit
              </Button>
            </div>
            {this.renderLocations()}
          </div>
        </div>
      </div>
    );
  }

  renderLocations() {
    if (!this.props.locations || this.props.locations.length < 0) {
      return <Spinner />;
    }
    return _.map(this.props.locations, (loc) => {
      return <Location key={loc.id} loc={loc} editing={this.state.editing} />;
    });
  }

  renderWeather() {
    if(!this.props.weather) {
      return <Spinner />;
    }
    return (
      <div>
        <p>{titleCase(this.weather.weather.description)}</p>
        <p>Temp: {this.weather.main.temp}F</p>
        <p>High: {this.weather.main.temp_max}F</p>
        <p>Low: {this.weather.main.temp_min}F</p>
        <p>Wind: {this.weather.wind.speed}mph</p>
        <p>Humidity: {this.weather.main.humidity}%</p>
      </div>
    );
  }
}

class Location extends React.Component {

  constructor(props) {
    super(props);
    this.state = {expanded: false, editing: this.props.editing}
  }

  toggle() { this.setState({expanded: !this.state.expanded}); }

  deleteLocation() {
    //TODO
    alert("delete location");
  }

  render() {
    let alerts = ''; //TODO load alerts for location
    if (!alerts) {
      return <Spinner />;
    } else {
      alerts = [];
    }


    let button = '';

    if (this.state.editing) {
      button = (
        <Button color="danger"
                className="float-right"
                onClick={this.deleteLocation.bind(this)}>
          Delete
        </Button>
      );
    } else {
      button = (
        <Button color="primary"
                className="float-right"
                onClick={this.toggle.bind(this)}>
          {this.state.expanded ? "Hide" : "Show"}
        </Button>
      );
    }

    return (
      <Card>
        <CardHeader>
          <h3>Location Name</h3>
          {button}
        </CardHeader>
        <Collapse isOpen={this.state.expanded && !this.state.editing}>
          <CardBody>
            {alerts}
          </CardBody>
        </Collapse>
      </Card>
    );
  }
}

function Alert(params) {
  return (
    <div>
      <Link to={`/alert/${params.alert_id}`}>Alert Name</Link>
      <p>extra info?</p>
    </div>
  );
}

export default connect((state) => state)(Home);
