import React,{ Component} from 'react';
import { connect } from 'react-redux';
import {Map, Marker, GoogleApiWrapper} from 'google-maps-react';
import {geolocated} from 'react-geolocated';
//import MapContainer from './mapcontainer';

class HomeMap extends Component {
	
	
	render() {
		let current_lat=null,current_lng=null,geoLocMsg;
		if(this.props.isGeolocationAvailable) {
			if(this.props.isGeolocationEnabled) {
				if(this.props.coords){
					current_lat = this.props.coords.latitude;
					current_lng = this.props.coords.longitude;
				}
			}
			else
				console.log("Geolocation is not enabled.");
		}
		else
			console.log("Browser does not support Geolocation.");
		console.log("Current Latitude ", current_lat);
		console.log("Current Longitude ", current_lng);

		console.log("Props", this.props);
		
		
		let style={
			width: '90%',
			height: '400px',
			position: 'relative',
		};
		
		return <Map 
			google={this.props.google}
			className={'map'}
			style={style}
		>
		</Map>
	}
}

function state2props(state) {
  return {
    state: state
  };
}

export default connect(state2props)(geolocated({
	positionOptions: {enableHighAccuracy: false},
	userDecisionTimeout: 5000,
})(GoogleApiWrapper({
	apiKey: 'AIzaSyBn7f8R1_N3F-Dtz51cUyXt_BmMvkzrSDU'
})(HomeMap)));
