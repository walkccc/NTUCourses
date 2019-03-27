import React, { Component } from 'react';
import './Header.css';

function Header(props){
    return(
        <header className="todo-app__header">
            <h1 className="todo-app__title">
                {props.title}
            </h1>
        </header>
    );
}

export default Header;