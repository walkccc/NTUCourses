import React, { Component } from "react";
import { NavLink, Switch, Route, Redirect } from "react-router-dom";

import Homes from "./Posts/Homes";
import Posts from "./Posts/Posts";
import PostRender from "./Posts/PostRender";
import AuthorRender from "./Authors/AuthorRender";
import Author from "./Authors/Author";
import './styles.css';

let headerUrl = './img/banner2.jpg'
let footerUrl = './img/footer.jpg'

export default class Blog extends Component {
    render() {
        return (
            <div>
                <div className="header" style={{backgroundImage: 'url(' + headerUrl + ')'}}>
                    <h3 style={{'paddingTop': '160px', 'fontFamily': 'Baloo Chettan', 'textShadow': '0.1em 0.1em #fff'}}>
                        <NavLink style={{ textDecoration: 'none', color: 'black' }} to="/home">Drift in Taiwan
                        </NavLink>
                    </h3>
                </div>
                <div className="row">
                    <div className="leftcolumn">
                        <Switch>
                            <Route exact path="/posts" component={Posts} />
                            <Route path="/posts/:id?" component={PostRender} />
                            <Redirect from="/home" to="/" component={Homes} />
                            <Route exact path="/" component={Homes} />
                            <Route exact path="/authors" component={Author} />
                            <Route path="/authors/:name?" component={AuthorRender} />
                        </Switch>
                    </div>
                    <div className="rightcolumn">
                        <div className="sidebar">
                            <h2>About Me</h2>
                            <div className="imgblock" style={{width: '85%'}}>
                                <img src={"./img/profile.jpg"} style={{height:'200px', 'borderRadius': '100px',}}/>
                            </div>
                            <p>Yi-Yen Hsieh, based in Taipei currently.</p>
                        </div>
                        <div className="sidebar">
                            <h2>
                                <NavLink style={{ textDecoration: 'none', color: 'grey' }} to="/home">Home</NavLink>
                            </h2>
                            <br/>
                            <h2>
                                <NavLink style={{ textDecoration: 'none', color: 'grey' }} to="/posts">Posts</NavLink>
                            </h2>
                            <br/>
                            <h2>
                                <NavLink style={{ textDecoration: 'none', color: 'grey' }} to="/authors">Authors</NavLink>
                            </h2>
                        </div>
                        <div className="sidebar">
                            <h2>Contact Me</h2>
                            <br />
                            <p>E-Mail: D06943001@ntu.edu.tw</p>
                        </div>
                    </div>
                </div>
                <div className="footer" style={{backgroundImage: 'url(' + footerUrl + ')'}}>
                </div>
            </div>
        );
    }
}
