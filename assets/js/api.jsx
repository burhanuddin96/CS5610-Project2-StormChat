import store from './store';

const weatherAPI = "ae122e8192b014da71c80636464532d8";

class TheServer {

  submitSignUp(data, onSuccess, onError) {
    $.ajax("/api/v1/users", {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify({ user_params: data }),
      success: (resp) => {
        store.dispatch({
          type: 'SUCCESS_MSG',
          success: 'Signed up successfully'
        });
        onSuccess();
      },
      error: (resp) => {
        console.log(resp.responseJSON.errors);
        if (resp.status == 422) {
          onError(resp.responseJSON.errors);
        }
      }
    });
  }

  submitLogin(data, onSuccess) {
    $.ajax("/api/v1/token", {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(data),
      success: (resp) => {
        store.dispatch({
          type: 'SET_USER',
          user: resp
        });
      },
      success: (resp) => { onSuccess(); },
      error: (resp) => {
        store.dispatch({
          type: 'ERROR_MSG',
          msg: "Login failed",
        });
      }
    });
  }

  //TODO
  updateUser(data) {
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

  getCurrentWeather(lat, lon) {
    let path = `api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&units=imperial&appid=${weatherAPI}`;
    $.ajax(path, {
      method: "get",
      success: (resp) => {
        store.dispatch({
          type: 'WEATHER',
          data: resp
        });
      }
    });
  }
}

export default new TheServer();
