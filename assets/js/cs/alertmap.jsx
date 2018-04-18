import React,{ Component} from 'react';
import { connect } from 'react-redux';
import {Polygon, Map, GoogleApiWrapper} from 'google-maps-react';

class AlertMap extends Component {
	constructor(props) {
    	super(props);
    }
	
	render() {
	
		//Test Polygon
		let poly = [[{lat: 40.7128, lng: -74.0060},
					{lat: 32.7767, lng: -96.7970},
					{lat: 39.0119, lng: -98.4842}],
					[{lat: 42.3601, lng: -71.0589},
					{lat: 28.5383, lng: -81.3792},
					{lat: 29.7604, lng: -95.3698}]];
		
		//Replace "poly" by this.props.polygons
		//Pass polygons from the parent calling function.
		let polygons = poly.map((p) => 
			<Polygon 
					paths={p}
					strokeColor="#0000FF"
					strokeOpacity={0.8}
					strokeWeight={2}
					fillColor="#0000FF"
					fillOpacity={0.35}
					key={p[0]['lat']}
					/>) 
		console.log("Props: ", this.props);
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
		{polygons}
		</Map>
	}
}


export default GoogleApiWrapper({
	apiKey: 'AIzaSyBn7f8R1_N3F-Dtz51cUyXt_BmMvkzrSDU'
})(AlertMap);
