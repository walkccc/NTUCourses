import React from 'react';
import PropTypes from 'prop-types';

class CalcButton extends React.Component {
  handleClick = () => this.props.onClick(this.props.name);

  render() {
    const { className, name } = this.props;
    const extraClass = className || '';

    return (
      <button className={`calc-btn ${extraClass}`} onClick={this.handleClick}>
        {name}
      </button>
    );
  }
}

CalcButton.propTypes = {
  className: PropTypes.string,
  onClick: PropTypes.func
};

export default CalcButton;
