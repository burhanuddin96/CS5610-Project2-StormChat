import React from 'react';
import { NavLink, Link } from 'react-router-dom';
import { Form, FormGroup, NavItem, Input, Button } from 'reactstrap';
import { connect } from 'react-redux';
import api from '../api';

let LoginForm = connect(({login}) => {return {login};})((props) => {
  function update(ev) {
    let tgt = $(ev.target);
    let data = {};
    data[tgt.attr('name')] = tgt.val();
    props.dispatch({
      type: 'UPDATE_LOGIN_FORM',
      data: data,
    });
  }

  function create_token(ev) {
    api.submit_login(props.login);
  }

  return <div className="navbar-text">
    <Form inline>
      <FormGroup>
        <Input type="text" name="email" placeholder="email"
               value={props.login.name} onChange={update} />
      </FormGroup>
      <FormGroup>
        <Input type="password" name="password" placeholder="password"
               value={props.login.password} onChange={update} />
      </FormGroup>
      <Button onClick={create_token}>Log In</Button>
    </Form>
    <p className="blockquote-footer text-right">{props.login.msg}</p>
  </div>;
});

let Session = connect(({edit_user_form}) => {return {edit_user_form};})((props) => {
  return <div className="navbar-text">
    Hello, {props.edit_user_form.name}!&nbsp;&nbsp;
    <Logout />
  </div>;
});

let Logout = connect((state) => {return {};})((props) => {
  function submit_logout(ev) {
    props.dispatch({
      type: 'LOG_OUT',
      msg: "Logged out successfully.",
    });
  }

  return <Link to="/" onClick={submit_logout} className="primary">Logout</Link>;
});

function Nav(props) {
  let to_my_tasks;
  let path;
  let nav_links;
  let session_info;

  // include navigation links only if a user has logged in
  if (props.token) {
    path = "/users/" + props.token.user_id;

    nav_links =
      <ul className="navbar-nav mr-auto">
        <NavItem>
          <NavLink to="/" exact={true} activeClassName="active"
            className="nav-link">home</NavLink>
        </NavItem>
        <NavItem>
          <NavLink to="/users" href="#" activeClassName="active"
            className="nav-link">users</NavLink>
        </NavItem>
        <NavItem>
          <NavLink to={path} href="#" activeClassName="active"
            className="nav-link">myAccount</NavLink>
        </NavItem>
      </ul>;
    session_info = <Session token={props.token} />;
  }
  else {
    nav_links = <span></span>;
    session_info = <LoginForm />;
  }

  return (
    <nav className="navbar navbar-dark bg-dark navbar-expand mb-3 justify-content-between">
      <span className="navbar-brand">StormChat</span>
      {nav_links}
      <span className="navbar-text text-right">{session_info}</span>
    </nav>
  );
}

function state2props(state) {
  return {
    token: state.token,
    current_user: state.current_user
  };
}

export default connect(state2props)(Nav);
