import React from 'react';
import CalcButton from './CalcButton';
import calculate from '../containers/calculate';

class CalcApp extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      total: null,
      prev: null,
      next: null,
      operation: null
    };
  }

  handleClick = buttonName => {
    this.setState(calculate(this.state, buttonName));
  };

  render() {
    console.log(this.state);

    return (
      <div className="calc-app">
        <div className="calc-container">
          <div className="calc-output">
            <div className="calc-display">{this.state.next || this.state.total || '0'}</div>
          </div>
          <div className="calc-row">
            <CalcButton name="AC" onClick={this.handleClick} />
            <CalcButton name="+/-" onClick={this.handleClick} />
            <CalcButton name="%" onClick={this.handleClick} />
            <CalcButton name="÷" onClick={this.handleClick} className="calc-operator" />
          </div>
          <div className="calc-row">
            <CalcButton name="7" onClick={this.handleClick} className="calc-number" />
            <CalcButton name="8" onClick={this.handleClick} className="calc-number" />
            <CalcButton name="9" onClick={this.handleClick} className="calc-number" />
            <CalcButton name="x" onClick={this.handleClick} className="calc-operator" />
          </div>
          <div className="calc-row">
            <CalcButton name="4" onClick={this.handleClick} className="calc-number" />
            <CalcButton name="5" onClick={this.handleClick} className="calc-number" />
            <CalcButton name="6" onClick={this.handleClick} className="calc-number" />
            <CalcButton name="-" onClick={this.handleClick} className="calc-operator" />
          </div>
          <div className="calc-row">
            <div className="calc-row">
              <CalcButton name="1" onClick={this.handleClick} className="calc-number" />
              <CalcButton name="2" onClick={this.handleClick} className="calc-number" />
              <CalcButton name="3" onClick={this.handleClick} className="calc-number" />
              <CalcButton name="+" onClick={this.handleClick} className="calc-operator" />
            </div>
          </div>
          <div className="calc-row">
            <div className="calc-row">
              <CalcButton name="0" onClick={this.handleClick} className="calc-number bigger-btn" />
              <CalcButton name="." onClick={this.handleClick} className="calc-number " />
              <CalcButton name="=" onClick={this.handleClick} className="calc-operator" />
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default CalcApp;
