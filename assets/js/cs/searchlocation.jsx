import React from 'react';
import { Form, FormGroup, Label, Input, Button } from 'reactstrap';
import { connect } from 'react-redux';
import api from '../api';


function SearchLocation(props) {

  function submit(ev) {
    ev.preventDefault();

    var $inputs = $('#search :input');
    var data = {};
    $inputs.each(function() {
      data[this.name] = $(this).val();
    });
    console.log("Place: ",data['name']);
    var place = data['name'].split(' ').join('+');
    var url = "https://maps.googleapis.com/maps/api/geocode/json?address="+ place +"&key=AIzaSyBn7f8R1_N3F-Dtz51cUyXt_BmMvkzrSDU";
    console.log("URL:", url);
    var loc = api.get_lat_lng(url);
    console.log("Location:", loc );
  }

  return (
    <Form>
      <FormGroup>
        <Input name="name" type="text" placeholder="Search" />
      </FormGroup>
      <Button onClick={submit} color="info">Add Location</Button>
    </Form>
  );
}

function state2props(state) {
  return {
    state: state
  };
}

export default connect(state2props)(SearchLocation);

