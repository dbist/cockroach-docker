import React, { Component } from 'react';
import PropTypes from 'prop-types';

class AddTask extends Component {
    constructor(props) {
        super(props);
        this.state = {
            description: null,
        };
        this.handleSave = this.handleSave.bind(this);
    }

    handleSave() {
        const { description } = this.state;
        if (description !== null && description.trim() !== "") {
            this.props.handleSave(description);
        }
    }

    handleDescriptionChange = event => {
        this.setState({ description: event.target.value });
    };

    render() {
        return (
            <div className="form-main">
                <div class="form-entry">
                    <p>Description:</p>
                    <input className="task" value={this.state.description} onChange={this.handleDescriptionChange} />
                </div>
                <div className="form-action">
                    <button className="" onClick={this.handleSave}>Save</button>
                </div>
            </div>
        );
    }
}

AddTask.propTypes = {
    handleSave: PropTypes.func.isRequired
};

export default AddTask;