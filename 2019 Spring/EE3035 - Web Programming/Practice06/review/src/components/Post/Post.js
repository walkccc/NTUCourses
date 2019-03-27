import React from "react";

export default ({ id, date, title, content, photourl}) => {
    return (
        <div className="article">
            <h2>Post #{id} -- {title}</h2>
            <br />
            <h3>Date: {date}</h3>
            <div class="imgblock">
                <img src={photourl} style={{height:'500px',}}/>
            </div>
            <p>{content}</p>
        </div>
    );
};
