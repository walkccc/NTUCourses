import React, { Component } from "react";
import { NavLink } from "react-router-dom";

export default class Posts extends Component {
    render() {
        const postIDs   = ["1", "2"];
        const lists = postIDs.map((i, index) => (
            <li key={index}>
                <NavLink style={{ textDecoration: 'none', color: 'grey' }} to={"/posts/" + i}>Posts #{i}</NavLink>
            </li>
        ));
        return (
            <div className="article">
                <h2>Click to view articles</h2>
                <br />
                <p> 這裡是所有的文章列表。</p>
                <br />
                {lists}
            </div>
        );
    }
}
