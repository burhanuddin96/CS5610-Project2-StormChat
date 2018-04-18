import React from 'react';
import { connect } from 'react-redux';

import UserNew from './user_new';
import HomeMap from './homemap';
import SearchLocation from './searchlocation';

function Home(props) {
  if (props.token == null) {
    return (
      <div>
        Please log in above or create an account below.
        <UserNew />   
      </div>
    );
  } else {
    return (
      <div>
      	<HomeMap />
        Chats (not yet functional)
      </div>
    );
  }
}

function state2props(state) {
  return {
    token: state.token
  };
}

export default connect(state2props)(Home);

