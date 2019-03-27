import React from 'react';

const Todo = ({ todo: { complete, text }, toggleComplete, onDelete }) => (
  <li
    className="task"
    style={{
      textDecoration: complete ? 'line-through' : '',
      color: complete ? '#bdc3c7' : '#34495e'
    }}
    onClick={toggleComplete}
  >
    <span onClick={toggleComplete}>
      {text}
      <span className="X" onClick={onDelete}>
        X
      </span>
    </span>
  </li>
);

export default Todo;
