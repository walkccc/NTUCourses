import React from 'react';

const Post = ({ avatar, title, author, timeAgo, content }) => {
  return (
    <div className="box">
      <article className="media">
        <div className="media-left">
          <figure className="image is-64x64">
            <img src={avatar} alt="avatar" />
          </figure>
        </div>
        {title}
      </article>
      <div className="media-content">
        <div className="content">
          <p>
            <strong>{author}</strong> <small>@{author}</small> <small>{timeAgo}</small>
            <br />
            {content}
          </p>
        </div>
        <nav className="level is-mobile">
          <div className="level-left">
            <a href="./" className="level-item" aria-label="reply">
              <span className="icon is-small">
                <i className="fas fa-reply" aria-hidden="true" />
              </span>
            </a>
            <a href="./" className="level-item" aria-label="retweet">
              <span className="icon is-small">
                <i className="fas fa-retweet" aria-hidden="true" />
              </span>
            </a>
            <a href="./" className="level-item" aria-label="like">
              <span className="icon is-small">
                <i className="fas fa-heart" aria-hidden="true" />
              </span>
            </a>
          </div>
        </nav>
      </div>
    </div>
  );
};

export default Post;
