import React, { Component } from 'react';
import './App.css';
import TodoList from './TodoList';

class App extends Component {
  render() {
    return (
      <div>
        <header>
          <h1>
            todo<span>list</span>
          </h1>
          <h2>A simple todo list app built with React</h2>
        </header>
        <TodoList />
      </div>
    );
  }
}

export default App;
