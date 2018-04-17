import React from 'react';
import { Redirect, Route } from 'react-router-dom';
import { connect } from 'react-redux';

let AuthRoute = connect(({user}) => {return {user};})((props) => {
  return (
    <Route path={props.path}
           render={
             props.user ?
             props.render :
             () => <Redirect to="/" />
           } />
  );
});

export default AuthRoute;
