import React from 'react';

import CalcButton from '../components/CalcButton';

// 計算機 App
class CalcApp extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      memory : 0,
      process : 0, 
      operator : "AC",
      stat : "AC",
      display : 0
    };
  }
  calculate = () => {
    var ret = 0;
    if (this.state.operator === "+") {
      ret = this.state.memory + this.state.process;
    }
    else if (this.state.operator === "-") {
      ret = this.state.memory - this.state.process;
    }
    else if (this.state.operator === "X") {
      ret = this.state.memory * this.state.process;
    }
    else if (this.state.operator === "÷") {
      ret = this.state.memory / this.state.process;
    }
    ret = +ret.toFixed(6);
    return ret;
  }    
  setDisplay = (num) => {
    this.setState({ display : num });
  };
  setProcess = (num) => {
    this.setState({ process : num });
  };
  setMemory = (num) => {
    this.setState({ memory : num });
  };
  setOperator = (op) => {
    this.setState({ operator : op });
  };
  setStatus = (st) => {
    this.setState({ stat : st });
  };
  resetState = e => {
    this.setProcess(0);
    this.setMemory(0);
    this.setOperator("AC");
    this.setStatus("AC");
    this.setDisplay(0);
  }
  handleNumber = e => {
    const input = +e.target.innerHTML;
    if (this.state.stat === "Num") {
      const process = this.state.process * 10 + input;
      this.setProcess(process);
      this.setDisplay(process);
    }
    else if (this.state.stat === "AC" || this.state.stat === "Eq") {
      this.setMemory("None");
      this.setProcess(input);
      this.setStatus("Num");
      this.setDisplay(input);
    }
    else {
      this.setProcess(input);
      this.setStatus("Num");
      this.setDisplay(input);
    }
  }
  handleOperator = e => {
    const input = e.target.innerHTML;
    if (this.state.stat === "Op") {
      this.setOperator(input);
    }
    else if (this.state.memory === "None") {
      this.setMemory(this.state.process);
      this.setOperator(input);
      this.setStatus("Op");
    }
    else if (this.state.stat === "Eq") {
      this.setOperator(input);
      this.setProcess(this.state.memory);
      this.setStatus("Op");
    }
    else {
      const calc = this.calculate();
      this.setMemory(calc);
      this.setProcess(calc);
      this.setOperator(input);
      this.setStatus("Op");
      this.setDisplay(calc); 
    }
  }
  handleEqual = e => {
    const calc = this.calculate();
    this.setMemory(calc);
    this.setDisplay(calc);
    this.setStatus("Eq");
  }
  showNotImplemented() {
    console.warn('This function is not implemented yet.');
  }

  render() {
    return (
      <div className="calc-app">
        <div className="calc-container">
          <div className="calc-output">
            <div className="calc-display">{this.state.display}</div>
          </div>
          <div className="calc-row">
            <CalcButton onClick={this.resetState}>AC</CalcButton>
            <CalcButton onClick={this.showNotImplemented}>+/-</CalcButton>
            <CalcButton onClick={this.showNotImplemented}>%</CalcButton>
            <CalcButton className="calc-operator" onClick={this.handleOperator}>÷</CalcButton>
          </div>
          <div className="calc-row">
            <CalcButton className="calc-number" onClick={this.handleNumber}>7</CalcButton>
            <CalcButton className="calc-number" onClick={this.handleNumber}>8</CalcButton>
            <CalcButton className="calc-number" onClick={this.handleNumber}>9</CalcButton>
            <CalcButton className="calc-operator" onClick={this.handleOperator}>X</CalcButton>
          </div>
          <div className="calc-row">
            <CalcButton className="calc-number" onClick={this.handleNumber}>4</CalcButton>
            <CalcButton className="calc-number" onClick={this.handleNumber}>5</CalcButton>
            <CalcButton className="calc-number" onClick={this.handleNumber}>6</CalcButton>
            <CalcButton className="calc-operator" onClick={this.handleOperator}>-</CalcButton>
          </div>
          <div className="calc-row">
            <CalcButton className="calc-number" onClick={this.handleNumber}>1</CalcButton>
            <CalcButton className="calc-number" onClick={this.handleNumber}>2</CalcButton>
            <CalcButton className="calc-number" onClick={this.handleNumber}>3</CalcButton>
            <CalcButton className="calc-operator" onClick={this.handleOperator}>+</CalcButton>
          </div>
          <div className="calc-row">
            <CalcButton className="calc-number bigger-btn" onClick={this.handleNumber}>0</CalcButton>
            <CalcButton className="calc-number">.</CalcButton>
            <CalcButton className="calc-operator" onClick={this.handleEqual}>=</CalcButton>
          </div>
        </div>
      </div>
    );
  }
}

export default CalcApp;
