import React, { Component } from 'react';

class Menu extends Component {
    render() {
        return (
            <ul className="nav navbar-nav menu_nav justify-content-center">
                {this.props.data.map((e, idx) => <li className={`nav-item ${idx === this.props.active ? 'active' : ''}`}><a className='nav-link' href={e.link}>{e.text}</a></li>)}
                <li className="nav-item submenu dropdown">
                <a href="/#" className="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                    aria-expanded="false">Pages</a>
                <ul className="dropdown-menu">
                    <li className="nav-item"><a className="nav-link" href="blog-details.html">Blog Details</a></li>
                </ul>
                </li>
                <li className="nav-item"><a className="nav-link" href="contact.html">Contact</a></li>
            </ul>
        );
    }
}

export default Menu;
