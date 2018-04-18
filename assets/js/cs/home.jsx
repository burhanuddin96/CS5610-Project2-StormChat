import React from 'react';
import { connect } from 'react-redux';
import { Button } from 'reactstrap';
import Spinner from './spinner';
import HomeMap from './homemap';
import SearchLocation from './searchlocation';
import api from '../api';

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
    api.getSavedLocations();
  }

  toggleEdit() { this.setState({editing: !this.state.editing}); }

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
                <h2 className="d-inline-block">Alerts by Location</h2>
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

  renderForm() {
    if (this.state.editing) {
      <SearchLocation />
    }
  }

  renderLocations() {
    let currentLoc = null;
    let savedLocs = null;
    let spinner = null;
    if (this.props.savedLocations && this.props.savedLocations.length > 0) {
      savedLocs = _.map(this.props.savedLocations, (loc) => {
        return <Location key={loc.id} loc={loc} editing={this.state.editing} />;
      });
    }
    if (this.props.currentLocation) {
      let data = {
        name: "Current Location",
        id: null,
        coords: this.props.currentLocation
      };
      currentLoc = <Location loc={data} editing={false} />;
    }
    if (!(currentLoc || savedLocs)) {
      spinner = <Spinner />;
    }

    return (
      <div>
        {currentLoc}
        {savedLocs}
        {spinner}
      </div>
    );
  }

  renderWeather() {
    if(!this.props.weather) {
      return <Spinner />;
    }
    let weather = this.props.weather;
    return (
      <table className="w-100 text-center">
        <tbody>
          <tr>
            <td className="align-middle">
              <img src={"http://openweathermap.org/img/w/" + weather.weather[0].icon + ".png"} />
            </td>
            <td className="align-bottom">
              <h3>{weather.main.temp} F</h3>
            </td>
            <td className="align-bottom">
              <h3>{weather.main.temp_min} F</h3>
            </td>
            <td className="align-bottom">
              <h3>{weather.main.temp_max} F</h3>
            </td>
            <td className="align-bottom">
              <h3>{weather.wind.speed} mph</h3>
            </td>
            <td className="align-bottom">
              <h3>{weather.main.humidity}%</h3>
            </td>
          </tr>
          <tr>
            <td className="align-top">
              <small>{titleCase(weather.weather[0].description)}</small>
            </td>
            <td className="align-top">
              <small>Current Temperature</small>
            </td>
            <td className="align-top">
              <small>Low</small>
            </td>
            <td className="align-top">
              <small>High</small>
            </td>
            <td className="align-top">
              <small>Wind Speed</small>
            </td>
            <td className="align-top">
              <small>Humidity</small>
            </td>
          </tr>
        </tbody>
      </table>
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
        <Button color="warning"
                className="float-right"
                onClick={this.deleteLocation.bind(this)}>
          Delete
        </Button>
      );
    } else {
      button = (
        <Button color="info"
                className="float-right"
                onClick={this.toggle.bind(this)}>
          {this.state.expanded ? "Hide" : "Show"}
        </Button>
      );
    }

    return (
      <Card>
        <CardHeader>
          <h4>Location Name</h4>
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
