import React from 'react';
import { Button, FormGroup, Label, Input } from 'reactstrap';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';
import api from '../api';

// a form to edit user information
function UserEdit(props) {
  if (props.token == null) {
    return <div>Please log in.</div>
  }

  function update(ev) {
    let tgt = $(ev.target);
    let attr = tgt.attr('name');
    let val = tgt.val();

    let data = {};
    data[attr] = val;

    let action = {
      type: 'UPDATE_EDIT_USER_FORM',
      data: data
    };
    props.dispatch(action);
  }

  function submit(ev) {
    let data = {
      token: props.token.token,
      user_params: {
        id: props.edit_user_form.id,
        name: props.edit_user_form.name,
        email: props.edit_user_form.email,
        phone: props.edit_user_form.phone,
        password: props.edit_user_form.password,
        password_confirmation: props.edit_user_form.password_confirmation
      }
    };

    api.update_user(data);
  }

  function clear(ev) {
    props.dispatch({
      type: 'CLEAR_EDIT_USER_FORM'
    });
  }

  let path = "/";

  // TODO: validate phone number input
  return <div className="card">
    <div className="card-body">
      <h2>Edit Account</h2>
      <FormGroup>
        <Label for="name">name:</Label>
        <Input name="name" value={props.edit_user_form.name}
          onChange={update} />
      </FormGroup>
      <FormGroup>
        <Label for="email">email:</Label>
        <Input type="email" name="email" value={props.edit_user_form.email}
          onChange={update} />
      </FormGroup>
      <FormGroup>
        <Label for="phone">phone:</Label>
        <Input name="phone" value={props.edit_user_form.phone}
          onChange={update} />
      </FormGroup>
      <FormGroup>
        <Label for="password">password:</Label>
        <Input type="password" name="password"
          value={props.edit_user_form.password} onChange={update} />
      </FormGroup>
      <FormGroup>
        <Label for="password_confirmation">confirm password:</Label>
        <Input type="password" name="password_confirmation"
          value={props.edit_user_form.password_confirmation}
          onChange={update} />
      </FormGroup>
      <Link to={path} onClick={submit} className="bp">submit changes</Link>
      <Link to={path} onClick={clear} className="bs">cancel</Link>
    </div>
  </div>;
}

function state2props(state) {
  return {
    edit_user_form: state.edit_user_form,
    token: state.token
  };
}

export default connect(state2props)(UserEdit);
