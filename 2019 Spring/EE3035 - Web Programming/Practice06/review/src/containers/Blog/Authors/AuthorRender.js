import React, { Component } from "react";

import Author from "../../../components/Author/Author";

export default class AuthorRender extends Component {
    render() {
        const authorNames = ["GB","Jocelyn"];
        const { name } = this.props.match.params;
        return name && authorNames.includes(name) ? (
            <Author name={name} />
        ) : (
            <div className="article">
                <h2>Error: Author - {name} NOT FOUND</h2>
            </div>
        );
    }
}
