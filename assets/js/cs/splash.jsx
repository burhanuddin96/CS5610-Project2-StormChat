import React from 'react';
import { Redirect } from 'react-router-dom';
import { connect } from 'react-redux';
import { Jumbotron, Form, FormFeedback, FormGroup, Label, Input, Button, Col } from 'reactstrap';
import api from '../api';

class Splash extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      state: 1,
      errors: {},
      redirect: false
    };
  }

  showAbout() {
    this.setState({state: 1});
    this.props.dispatch({
      type: 'RESET_FORMS'
    });
  }

  showLogin() { this.setState({state: 2}); }

  showSignUp() { this.setState({state: 3}); }

  update(ev, type) {
    let target = $(ev.target);
    let data = {};
    data[target.attr('name')] = target.val();
    this.props.dispatch({
      type: type,
      data: data
    });
  }

  updateLogin(ev) { this.update(ev, 'UPDATE_LOGIN'); }

  updateSignUp(ev) { this.update(ev, 'UPDATE_SIGNUP'); }

  submitLogin() {
    api.submitLogin(
      this.props.login,
      (() => {this.setState({redirect: true});}).bind(this)
    );
  }

  submitSignUp() {
    api.submitSignUp(
      this.props.signUp,
      this.showAbout.bind(this),
      ((fields) => {
        this.setState({errors: fields});
      }).bind(this)
    );
  }

  feedback(field) {
    if (this.state.errors[field]) {
      return <FormFeedback>{this.state.errors[field][0]}</FormFeedback>;
    }
    return '';
  }

  render() {
    if (this.state.redirect) {
      return <Redirect to={this.props.redirect ? this.props.redirect : "/home"} />;
    }

    let body = '';
    switch(this.state.state) {
      case 2: body = this.renderLogin(); break;
      case 3: body = this.renderSignUp(); break;
      default: body = this.renderAbout();
    }

    return (
      <div className="container-fluid">
        <Jumbotron>{ body }</Jumbotron>
      </div>
    );
  }

  renderAbout() {
    return (
      <div className="fade-in">
        <h1>StormChat</h1>
        <h4>Put some buzzword-y blurb here with a basic overview of the app</h4>
        <Button onClick={this.showLogin.bind(this)}
                color="info">
          Login
        </Button>
        <span> - OR - </span>
        <Button onClick={this.showSignUp.bind(this)}
                color="secondary">
          Sign Up
        </Button>
      </div>
    );
  }

  renderLogin() {
    let update = this.updateLogin.bind(this);
    return (
      <div className="fade-in">
        <h2>Log In</h2>
        <Form>
          <FormGroup row>
            <Label for="email" sm={2}>Email:</Label>
            <Col sm={10}>
              <Input type="email" name="email" placeholder="user@example.com"
                     onChange={update} />
            </Col>
          </FormGroup>
          <FormGroup row>
            <Label for="password" sm={2}>Password:</Label>
            <Col sm={10}>
              <Input type="password" name="password" placeholder="password"
                     onChange={update} />
            </Col>
          </FormGroup>
          <FormGroup row>
            <Col sm={2}>
              <Button onClick={this.submitLogin.bind(this)}
                      color="info">Login</Button>
            </Col>
            <Col sm={2}>
              <Button onClick={this.showAbout.bind(this)}
                      color="secondary">Back</Button>
            </Col>
          </FormGroup>
        </Form>
      </div>
    );
  }

  renderSignUp() {
    console.log('RENDER');
    console.log(this.state.errors);
    console.log(this.feedback('name'));

    let update = this.updateSignUp.bind(this);
    return (
      <div className="fade-in">
        <h2>Sign Up</h2>
        <Form>
          <FormGroup row>
            <Label for="name" sm={3}>Display Name:</Label>
            <Col sm={9}>
              <Input type="text" name="name" placeholder="display name"
                     onChange={update} />
              {this.feedback('name')}
            </Col>
          </FormGroup>
          <FormGroup row>
            <Label for="email" sm={3}>Email:</Label>
            <Col sm={9}>
              <Input type="email" name="email" placeholder="user@example.com"
                     onChange={update} />
              {this.feedback('email')}
            </Col>
          </FormGroup>
          <FormGroup row>
            <Label for="phone" sm={3}>Phone Number:</Label>
            <Col sm={9}>
              <Input type="number" name="phone" placeholder="10-digit number"
                     min="1000000000" max="9999999999"
                     onChange={update} />
              {this.feedback('phone')}
            </Col>
          </FormGroup>
          <FormGroup row>
            <Label for="password" sm={3}>Password:</Label>
            <Col sm={9}>
              <Input type="password" name="password" placeholder="password"
                     onChange={update} />
              {this.feedback('password')}
            </Col>
          </FormGroup>
          <FormGroup row>
            <Label for="password_confirmation" sm={3}>Confirm Password:</Label>
            <Col sm={9}>
              <Input type="password" name="password_confirmation"
                     placeholder="confirm password" onChange={update} />
              {this.feedback('password_confirmation')}
            </Col>
          </FormGroup>
          <FormGroup row>
            <Col sm={2}>
              <Button onClick={this.submitSignUp.bind(this)}
                      color="info">Sign Up</Button>
            </Col>
            <Col sm={2}>
              <Button onClick={this.showAbout.bind(this)}
                      color="secondary">Back</Button>
            </Col>
          </FormGroup>
        </Form>
      </div>
    );
  }
}

export default connect((state) => {return state;})(Splash);
