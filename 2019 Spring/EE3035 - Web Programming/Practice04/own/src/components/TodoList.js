import React, { Component } from 'react';
import TodoForm from './TodoForm';
import Todo from './Todo';

class TodoList extends Component {
  state = {
    todos: [],
    currTab: 'all',
    tabs: ['all', 'active', 'complete']
  };

  addTodo = newTodo => {
    if (newTodo.text !== '') {
      this.setState(state => ({
        todos: [newTodo, ...state.todos]
      }));
    }
  };

  toggleComplete = id => {
    this.setState(state => ({
      todos: state.todos.map(todo => {
        if (todo.id === id) {
          return {
            ...todo,
            complete: !todo.complete
          };
        } else {
          return todo;
        }
      })
    }));
  };

  toggleTodoTab = currTab => {
    this.setState({ currTab });
  };

  handleDeleteTodo = id => {
    this.setState(state => ({
      todos: state.todos.filter(todo => todo.id !== id)
    }));
  };

  removeComplete = () => {
    this.setState(state => ({
      todos: state.todos.filter(todo => !todo.complete)
    }));
  };

  renderTodos = todos => {
    return todos.map(todo => (
      <Todo
        key={todo.id}
        toggleComplete={() => this.toggleComplete(todo.id)}
        onDelete={() => this.handleDeleteTodo(todo.id)}
        todo={todo}
      />
    ));
  };

  renderTabs = currTab => {
    return this.state.tabs.map(tab => {
      return (
        <button
          key={tab}
          className={tab === currTab ? 'button selected' : 'button'}
          onClick={() => this.toggleTodoTab(tab)}
        >
          {tab}
        </button>
      );
    });
  };

  render() {
    let todos = [];

    if (this.state.currTab === 'all') {
      todos = this.state.todos;
    } else if (this.state.currTab === 'active') {
      todos = this.state.todos.filter(todo => !todo.complete);
    } else if (this.state.currTab === 'complete') {
      todos = this.state.todos.filter(todo => todo.complete);
    }

    return (
      <article>
        <TodoForm onSubmit={this.addTodo} />
        <div style={{ marginBottom: 10 }}>
          todos left: {this.state.todos.filter(todo => !todo.complete).length}
        </div>

        <div>
          {this.renderTabs(this.state.currTab)}
          {this.state.todos.some(todo => todo.complete) ? (
            <button className="button clear" onClick={this.removeComplete}>
              remove completed
            </button>
          ) : null}
        </div>

        <ul className="list">{this.renderTodos(todos)}</ul>
      </article>
    );
  }
}

export default TodoList;
