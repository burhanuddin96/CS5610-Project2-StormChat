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
          msg: 'Signed up successfully'
        });
        onSuccess();
      },
      error: (resp) => {
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
        store.dispatch({
          type: 'SUCCESS_MSG',
          msg: `Welcome back, ${resp.name}!`
        });
        onSuccess();
      },
      error: (resp) => {
        store.dispatch({
          type: 'ERROR_MSG',
          msg: 'Login failed'
        });
      }
    });
  }

  submitSettings(userId, settings, onSuccess, onError) {
    let data = Object.assign({}, settings);
    if (!(data['password'] || data['password_confirmation'])) {
      if (data['password'])delete data['password'];
      delete data['password_confirmation'];
    }

    $.ajax(`/api/v1/users/${userId}`, {
      method: "put",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify({
        token: this.token,
        user_params: data
      }),
      success: (resp) => {
        store.dispatch({
          type: 'SUCCESS_MSG',
          msg: 'Settings updated'
        });
        store.dispatch({
          type: 'UPDATE_USER',
          user: resp.data
        });
        onSuccess();
      },
      error: (resp) => {
        if (resp.status == 422) {
          onError(resp.responseJSON.errors);
        }
      }
    });
  }

  deleteAccount(userId, onSuccess) {
    $.ajax(`/api/v1/users/${userId}?token=${this.token}`, {
      method: "delete",
      success: (resp) => {
        store.dispatch({type: 'DELETE_USER'});
        store.dispatch({
          type: 'SUCCESS_MSG',
          msg: 'Account deleted successfully'
        });
        onSuccess();
      }
    });
  }

  getSavedLocations() {
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
    let path = "https://api.openweathermap.org/data/2.5/weather?" + `lat=${lat}&lon=${lon}&units=imperial&appid=${weatherAPI}`;
    $.ajax(path, {
      method: "get",
      success: (resp) => {
        console.log(resp);
        store.dispatch({
          type: 'WEATHER',
          data: resp
        });
      }
    });
  }

  addLocation(url) {
    $.getJSON(url, (json) => {
      if(json['status'] == 'OK') {
        let name = json['results'][0]['formatted_address'];
        let lat_lng = json['results'][0]['geometry']['location'];
        console.log(name, lat_lng);
      } else {
        store.dispatch({
          type: 'ERROR_MSG',
          msg: 'Could not find location. Try entering an address, postal code, or city name.'
        });
      }
    });
  }
}


export default new TheServer();
