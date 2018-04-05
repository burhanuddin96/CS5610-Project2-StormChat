import store from './store';

class TheServer {
  request_users() {
    $.ajax("/api/v1/users", {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        store.dispatch({
          type: 'USERS_LIST',
          users: resp.data,
        });
      },
    });
  }

  submit_user(data) {
    $.ajax("/api/v1/users", {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify({ user_params: data }),
      success: (resp) => {},
    });
  }

  update_user(data) {
    let path = "/api/v1/users/" + data.user_params.id;

    $.ajax(path, {
      method: "patch",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify({ token: data.token, user_params: data.user_params }),
      success: (resp) => {
        this.request_users();
      },
    });
  }

  submit_login(data) {
    $.ajax("/api/v1/token", {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(data),
      success: (resp) => {
        store.dispatch({
          type: 'SET_TOKEN',
          token: resp
        });
        this.request_users();
        this.request_current_user(resp);
      },
    });
  }

  request_current_user(data) {
    let path = "/api/v1/users/" + data.user_id;

    $.ajax(path, {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        store.dispatch({
          type: 'UPDATE_EDIT_USER_FORM',
          data: {
            id: resp.data.id,
            name: resp.data.name,
            email: resp.data.email,
            phone: resp.data.phone
          }
        });
      },
    });
  }

}

export default new TheServer();
