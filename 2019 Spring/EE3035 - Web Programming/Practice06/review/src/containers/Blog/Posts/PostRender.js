import React, { Component } from "react";
import Post from "../../../components/Post/Post";

export default class PostRender extends Component {
    render() {
        const postIDs = ["1", "2"];
        const postDates = ["2019/04/08", "2019/04/10"];
        const postTitles = ["This is a photo of NTU", "Playground"];
        const postContents = [ "This is a good scene", "Want to play here all day"];
        const postPhotos = ["https://i.imgur.com/KSoA1ff.jpg", "https://i.imgur.com/Q5H2Rd0.jpg"]
        const {id} = this.props.match.params;
        
        return id && postIDs.includes(id)? (
            <Post id={id} date={postDates[id-1]} title={postTitles[id-1]} content={postContents[id-1]} photourl={postPhotos[id-1]}/>
        ) : (
            <div className="article">
                <h3>Error: Post #{id} NOT FOUND</h3>
            </div>
        );
    }
}
