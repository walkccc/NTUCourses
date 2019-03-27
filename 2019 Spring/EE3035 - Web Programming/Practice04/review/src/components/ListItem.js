import React, { Component } from 'react';
import './ListItem.css';

import xButton from '../assets/x.png';

function ListItem(props){
    return(
        <li className="todo-app__item">
            <div className="todo-app__checkbox">
                <input 
                    className={"todo-item-input"}
                    type="checkbox" 
                    id={props.id}
                    onChange={props.onMarkItem}
                    checked={props.done}
                    //defaultChecked
                >
                </input>
                <label htmlFor={props.id}></label>
            </div>
            <h1 className={props.done ? "todo-app__item-detail-checked" : "todo-app__item-detail"}>{props.content}</h1>
            <img 
                src={xButton} 
                className="todo-app__item-x" 
                onClick={props.onDeleteItem}
                id={props.id}
            >
            </img>
        </li>
    );
}

export default ListItem;