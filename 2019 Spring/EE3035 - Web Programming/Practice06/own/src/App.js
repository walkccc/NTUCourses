import 'bulma/css/bulma.min.css';
import './App.css';
import React from 'react';
import { BrowserRouter, Route } from 'react-router-dom';
import Header from './layout/Header';
import Content from './layout/Content';
import Footer from './layout/Footer';

const Photo = () => {
  return (
    <section className="hero is-link is-medium is-bold">
      <div className="hero-body">
        <div className="container has-text-centered">
          <h1 className="title">This is the /photos route.</h1>
        </div>
      </div>
    </section>
  );
};

const Archive = () => {
  return (
    <section className="hero is-primary is-medium is-bold">
      <div className="hero-body">
        <div className="container has-text-centered">
          <h1 className="title">This is the /archives route.</h1>
        </div>
      </div>
    </section>
  );
};

const About = () => {
  return (
    <section className="hero is-warning is-medium is-bold">
      <div className="hero-body">
        <div className="container has-text-centered">
          <h1 className="title">This is the /about route.</h1>
        </div>
      </div>
    </section>
  );
};

const App = () => {
  return (
    <div>
      <BrowserRouter>
        <div>
          <Header />
          <Route path="/" exact component={Content} />
          <Route path="/photos" exact component={Photo} />
          <Route path="/archives" exact component={Archive} />
          <Route path="/about" exact component={About} />
          <Footer />
        </div>
      </BrowserRouter>
    </div>
  );
};

export default App;
