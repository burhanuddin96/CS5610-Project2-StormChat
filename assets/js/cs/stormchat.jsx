import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import { Provider, connect } from 'react-redux';

import Nav from "./nav";
import Home from "./home";
import Users from "./users";
import UserEdit from "./user_edit";

export default function stormchat_init(store) {
  let root = document.getElementById('root');
  ReactDOM.render(<Provider store={store}><Stormchat /></Provider>, root);
}

let Stormchat = connect((state) => state)((props) => {
  return (
    <Router>
      <div>
        <Nav />
        <Route path="/" exact={true} render={() =>
          <Home />
        } />
        <Route path="/users" exact={true} render={() =>
          <Users />
        } />
        <Route path="/users/:user_id" render={() =>
          <UserEdit />
        } />
      </div>
    </Router>
  );
});

// import socket from "./socket";
// let channel = socket.channel("games:" + window.gameName, {});
// run_reversi(root, channel);
