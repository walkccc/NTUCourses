import React, { Component } from 'react';
import shortid from 'shortid';

class TodoForm extends Component {
  state = {
    text: ''
  };

  handleChange = e => {
    this.setState({
      [e.target.name]: e.target.value
    });
  };

  handleSubmit = e => {
    e.preventDefault();
    this.props.onSubmit({
      id: shortid.generate(),
      text: this.state.text,
      complete: false
    });
    this.setState({
      text: ''
    });
  };

  render() {
    return (
      <form className="form" onSubmit={this.handleSubmit}>
        <input
          className="input"
          name="text"
          value={this.state.text}
          onChange={this.handleChange}
          placeholder="Insert your task here..."
        />
        {/* <button onClick={this.handleSubmit}>add todo</button> */}
      </form>
    );
  }
}

export default TodoForm;
