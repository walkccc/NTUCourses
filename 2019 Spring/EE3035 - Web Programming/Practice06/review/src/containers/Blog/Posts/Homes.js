import React, { Component } from "react";

let homeimgurl = "./img/home.jpg";

export default class Homes extends Component {
    render() {
        return (
            <div className="article">
                <h2>Here is the home page</h2>
                <br />
                <div class="imgblock">
                    <img src={homeimgurl} style={{width:'650px',}}/>
                </div>
                <p>這是春假期間去日本玩時拍的照片，隨意逛逛。</p>
            </div>
        );
    }
}
