import React from 'react';
import 'bulma/css/bulma.min.css';
import './App.css';
import Header from './layout/Header';
import Content from './layout/Content';
import Footer from './layout/Footer';

const App = () => {
  return (
    <div>
      <Header />
      <Content />
      <Footer />
    </div>
  );
};

export default App;
