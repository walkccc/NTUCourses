import React from 'react';
import faker from 'faker';
import Post from '../components/posts/Post';

const Content = () => (
  <div>
    <section className="hero is-info is-medium is-bold">
      <div className="hero-body">
        <div className="container has-text-centered">
          <h1 className="title">This is the / route.</h1>
        </div>
      </div>
    </section>

    <div className="container">
      <Post
        title={faker.lorem.sentence()}
        author={faker.internet.userName()}
        timeAgo="Today at 4:45PM"
        content={faker.lorem.paragraphs()}
        avatar={faker.image.avatar()}
      />
      <Post
        title={faker.lorem.sentence()}
        author={faker.internet.userName()}
        timeAgo="Today at 2:00AM"
        content={faker.lorem.paragraphs()}
        avatar={faker.image.avatar()}
      />
      <Post
        title={faker.lorem.sentence()}
        author={faker.internet.userName()}
        timeAgo="Yesterday at 5:00PM"
        content={faker.lorem.paragraphs()}
        avatar={faker.image.avatar()}
      />
    </div>
  </div>
);

export default Content;
