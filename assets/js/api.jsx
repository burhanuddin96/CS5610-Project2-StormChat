import store from './store';

const weatherAPI = "ae122e8192b014da71c80636464532d8";

class TheServer {

  constructor() {
    this.token = null;
    store.subscribe(this.listener.bind(this));
  }

  listener() {
    let state = store.getState();
    this.token = state.user ? state.user.token : null;
  }

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
        onSuccess();
      },
      error: (resp) => {
        store.dispatch({
          type: 'ERROR_MSG',
          msg: "Login failed",
        });
      }
    });
  }

  getSavedLocations() {
    if (!this.token) {
      store.dispatch({
        type: 'ERROR_MSG',
        msg: 'No token!'
      });
      return;
    }
    $.ajax(`/api/v1/locations?token=${this.token}`, {
      method: "get",
      success: (resp) => {
        store.dispatch({
          type: 'SAVED_LOCATIONS',
          data: resp.data
        });
      }
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
