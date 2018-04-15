import { createStore, combineReducers } from 'redux';
import deepFreeze from 'deep-freeze';

/*
*  state layout:
*  {
*   users: [... Users ...],
*   user: {
*     name: string,
*     email: string,
*     phone: string
*   }
*   new_user_form: {
*     name: string,
*     email: string,
*     phone: string,
*     password: string,
*     password_confirmation: string
*   },
*   edit_user_form: {
*     id: integer,
*     name: string,
*     email: string,
*     phone: string,
*     password: string,
*     password_confirmation: string
*   },
*   token: {
*     token: string,
*     user_id: integer
*   },
*   login: {
*     email: string,
*     password: string,
	  msg: "",
*   }
* }
* */

function users(state = [], action) {
  switch (action.type) {
    case 'USERS_LIST':
      return [...action.users];
      case 'ADD_USER':
        return [action.user, ...state];
    case 'LOG_OUT':
      return [];
    default:
      return state;
  }
}

let empty_new_user_form = {
  name: "",
  email: "",
  phone: "",
  password: "",
  password_confirmation: ""
};

function new_user_form(state = empty_new_user_form, action) {
  switch (action.type) {
    case 'UPDATE_NEW_USER_FORM':
      return Object.assign({}, state, action.data);
    case 'CLEAR_NEW_USER_FORM':
      return empty_new_user_form;
    case 'LOG_OUT':
      return empty_new_user_form;
    default:
      return state;
  }
}

let empty_edit_user_form = {
  id: "",
  name: "",
  email: "",
  phone: "",
  password: "",
  password_confirmation: ""
};

function edit_user_form(state = empty_edit_user_form, action) {
  switch (action.type) {
    case 'UPDATE_EDIT_USER_FORM':
      return Object.assign({}, state, action.data);
    case 'CLEAR_EDIT_USER_FORM':
      return empty_edit_user_form;
    case 'LOG_OUT':
      return empty_edit_user_form;
    default:
      return state;
  }
}

function token(state = null, action) {
  switch (action.type) {
    case 'SET_TOKEN':
      return action.token;
    case 'LOG_OUT':
      return null;
    default:
      return state;
  }
}

let empty_login = {
  email: "",
  password: "",
  msg: ""
};

function login(state = empty_login, action) {
  switch (action.type) {
    case 'UPDATE_LOGIN_FORM':
      return Object.assign({}, state, action.data);
    case 'LOG_OUT':
      return Object.assign({}, empty_login, {msg: action.msg});
    default:
      return state;
  }
}

function root_reducer(state0, action) {
  console.log("state0", state0)
  // {tasks, users, form} is ES6 shorthand for
  // {tasks: tasks, users: users, form: form}
  let reducer = combineReducers({users, new_user_form, edit_user_form, token, login});
  let state1 = reducer(state0, action);
  console.log("state1", state1)
  return deepFreeze(state1);
};

let store = createStore(root_reducer);
export default store;
