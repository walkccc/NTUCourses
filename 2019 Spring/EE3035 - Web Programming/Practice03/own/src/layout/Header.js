import React, { Component } from 'react';
import Logo from '../img/logo.png';

class Header extends Component {
  state = {
    isActive: false
  };

  toggleNav = () => {
    this.setState(prevState => ({
      isActive: !prevState.isActive
    }));
  };

  render() {
    return (
      <nav
        className="navbar"
        aria-label="main navigation"
        style={{
          borderBottom: 'solid 1px #dddddd'
        }}
      >
        <div className="navbar-brand">
          <a href="./" className="navbar-item">
            <img
              style={{
                borderTopLeftRadius: '80%',
                borderTopRightRadius: '80%',
                borderBottomLeftRadius: '80%',
                borderBottomRightRadius: '80%',
                marginRight: 15
              }}
              src={Logo}
              width="30px"
              alt=""
            />
            <span>
              <strong>Show Me The Code</strong>
            </span>
          </a>
          <button className="button navbar-burger" onClick={this.toggleNav}>
            <span />
            <span />
            <span />
          </button>
        </div>
        <div className={this.state.isActive ? 'navbar-menu is-active' : 'navbar-menu'}>
          <div className="navbar-start">
            <a href="./" className="navbar-item">
              <span className="icon has-text-primary" style={{ marginRight: 5 }}>
                <i className="fa fa-home" />
              </span>
              Home
            </a>
            <a href="./" className="navbar-item">
              <span className="icon" style={{ marginRight: 5 }}>
                <i className="fa fa-camera" />
              </span>
              Photos
            </a>
            <a href="./" className="navbar-item">
              <span className="icon" style={{ marginRight: 5 }}>
                <i className="far fa-file-alt" />
              </span>
              Archives
            </a>
            <a href="./" className="navbar-item">
              <span className="icon" style={{ marginRight: 5 }}>
                <i className="fa fa-user" />
              </span>
              About
            </a>
          </div>
          <div className="navbar-end">
            <div className="navbar-item has-dropdown is-hoverable">
              <a href="./" className="navbar-link">
                Account
              </a>
              <div className="navbar-dropdown">
                <a href="./" className="navbar-item">
                  Setting
                </a>
                <hr className="navbar-divider" />
                <a href="./" className="navbar-item">
                  Logout
                </a>
              </div>
            </div>
          </div>
        </div>
      </nav>
    );
  }
}

export default Header;
