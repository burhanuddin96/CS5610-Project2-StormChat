import React from 'react';
import { Button, FormGroup, Label, Input } from 'reactstrap';
import { connect } from 'react-redux';
import api from '../api';

// form to create a new user
function UserNew(props) {
  function update(ev) {
    let tgt = $(ev.target);

    let data = {};
    data[tgt.attr('name')] = tgt.val();
    let action = {
      type: 'UPDATE_NEW_USER_FORM',
      data: data
    };
    props.dispatch(action);
  }

  function submit(ev) {
    api.submit_user(props.new_user_form);
    props.dispatch({
      type: 'CLEAR_NEW_USER_FORM'
    });
  }

  function clear(ev) {
    props.dispatch({
      type: 'CLEAR_NEW_USER_FORM'
    });
  }

  // TODO: validate phone number input
  return <div className="card">
    <div className="card-body">
      <h2>Create an Account</h2>
      <FormGroup>
        <Label for="name">name:</Label>
        <Input name="name" value={props.new_user_form.name} onChange={update} />
      </FormGroup>
      <FormGroup>
        <Label for="email">email:</Label>
        <Input type="email" name="email" value={props.new_user_form.email}
          onChange={update} />
      </FormGroup>
      <FormGroup>
        <Label for="phone">email:</Label>
        <Input name="phone" value={props.new_user_form.phone}
          onChange={update} />
      </FormGroup>
      <FormGroup>
        <Label for="password">password:</Label>
        <Input type="password" name="password"
          value={props.new_user_form.password} onChange={update} />
      </FormGroup>
      <FormGroup>
        <Label for="password_confirmation">confirm password:</Label>
        <Input type="password" name="password_confirmation"
          value={props.new_user_form.password_confirmation} onChange={update} />
      </FormGroup>
      <Button onClick={submit} color="primary">create account</Button>
      <Button onClick={clear} color="secondary">cancel</Button>
    </div>
  </div>;
}

function state2props(state) {
  return {
    new_user_form: state.new_user_form
  };
}

export default connect(state2props)(UserNew);
