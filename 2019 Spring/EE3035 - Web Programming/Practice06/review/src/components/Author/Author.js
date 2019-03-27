import React from "react";

export default ({ name }) => {
    return (
        <div className="article">
            <h2>Author - {name}</h2>
            <br />
            <p>This is the {name}'s profile</p>
        </div>
    );
};
