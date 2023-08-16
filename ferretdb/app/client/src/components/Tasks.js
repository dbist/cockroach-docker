import React, {Component} from 'react';
import PropTypes from 'prop-types';
import Task from './Task';

export default class Tasks extends Component {
    toggleTaskStatus = (task) => this.props.toggleTaskStatus(task);
    deleteTask = (id) => this.props.deleteTask(id);

    renderTasks() {
        return this.props.tasks.map(task => (
            <Task key={task.id} task={task} toggleTaskStatus={this.toggleTaskStatus} deleteTask={this.deleteTask} />
        ))
    }

    render() {
        return (
            <div className="width-70 display-inline-block center">
                {this.renderTasks()}
            </div>
        );
    }
}

Tasks.propTypes = {
    tasks: PropTypes.array.isRequired,
    toggleTaskStatus: PropTypes.func.isRequired,
    deleteTask: PropTypes.func.isRequired
};
