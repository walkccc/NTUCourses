import React, { Component } from 'react';
import NavBarToggler from './NavbarToggler';
import AppConfig from './AppConfig';
import AppSocial from './AppSocial'
import Menu from './Menu';

class Header extends Component {
    render() {
        return (
            <header className="header_area">
                <div className="main_menu">
                    <nav className="navbar navbar-expand-lg navbar-light">
                    <div className="container box_1620">
                        <a className="navbar-brand logo_h" href="index.html"><img src="img/logo.png" alt="" /></a>
                        <NavBarToggler />
                        <div className="collapse navbar-collapse offset" id="navbarSupportedContent">
                        <Menu data={AppConfig.navigator} active={0} />
                        <ul className="nav navbar-nav navbar-right navbar-social">
                            {AppSocial.navigator.map(e => <li><a href={e.link}><i className={e.class_name}></i></a></li>)}
                        </ul>
                        </div> 
                    </div>
                    </nav>
                </div>
            </header>
        );
    }
}

export default Header;
