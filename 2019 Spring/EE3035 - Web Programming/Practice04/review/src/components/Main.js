import React, { Component } from 'react';
import './Main.css';
import ListItem from './ListItem';

function Main(props) {
    const todoItems = props.items.map(item => 
        <ListItem 
            id={item.id} 
            content={item.content}
            done={item.done}
            key={item.id}
            onDeleteItem={props.onDeleteItem}
            onMarkItem={props.onMarkItem}
        />
    );
    return(
        <section className="todo-app__main">
            <input
                className="todo-app__input"
                placeholder="Enter todo items..."
                onKeyPress={props.onUserInput}>
            </input>
            <ul className="todo-app__list">
                {todoItems}
            </ul>
        </section>
    );
}

export default Main;