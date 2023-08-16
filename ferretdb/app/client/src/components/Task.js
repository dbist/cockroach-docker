import React, {Component} from 'react';
import PropTypes from 'prop-types';
import Checkbox from './Checkbox';
import trash from '../images/trash.png';

export default class Task extends Component {
    constructor(props) {
        super(props);
        this.toggleTaskStatus = this.toggleTaskStatus.bind(this);
        this.deleteTask = this.deleteTask.bind(this);
    }

    toggleTaskStatus() {
        this.props.task.completed = !this.props.task.completed;
        this.props.toggleTaskStatus(this.props.task);
    }

    deleteTask = () => this.props.deleteTask(this.props.task.id);

    getDescriptionCss(task) {
        let cssClass = "float-left width-70 text-align-left";
        if (task.completed) {
            cssClass += " task-completed";
        }
        return cssClass;
    }

    render() {
        const task = this.props.task;
        return (
            <div className="task-item">
                <div className="float-left width-15">
                    <Checkbox isChecked={Boolean(task.completed)} handleCheckboxChange={this.toggleTaskStatus} />
                </div>
                <div className={this.getDescriptionCss(task)}>
                    {task.description}
                </div>
                <div className="float-left width-15">
                    <img className="float-left clickable" src={trash} alt="delete" onClick={this.deleteTask} />
                </div>
                <div style={{clear:'both'}} />
            </div>
        );
    }
}

Task.propTypes = {
    task: PropTypes.object.isRequired,
    toggleTaskStatus: PropTypes.func.isRequired,
    deleteTask: PropTypes.func.isRequired
};
