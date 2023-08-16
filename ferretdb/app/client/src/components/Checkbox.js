import React, { Component } from 'react';
import PropTypes from 'prop-types';

class Checkbox extends Component {
  render() {
    const { isChecked, handleCheckboxChange } = this.props;
    return (
      <div className="checkbox">
        <input
            type="checkbox"
            checked={isChecked}
            onChange={handleCheckboxChange}
          />
      </div>
    );
  }
}

Checkbox.propTypes = {
  isChecked: PropTypes.bool.isRequired,
  handleCheckboxChange: PropTypes.func.isRequired
};

export default Checkbox;