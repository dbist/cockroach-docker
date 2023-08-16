import React, {Component} from 'react';
import Modal from 'react-modal';
import Tasks from './Tasks';
import AddTask from './AddTask';
import close from '../images/close.png';

export default class Dashboard extends Component {

    todo_api_url = "/api/tasks";

    constructor(props) {
        super(props);
        this.state = {
            isAddTaskOpen: false,
            tasks: [],
        };
        this.toggleTaskStatus = this.toggleTaskStatus.bind(this);
        this.toggleAddTaskModal = this.toggleAddTaskModal.bind(this);
        this.deleteTask = this.deleteTask.bind(this);
        this.addTask = this.addTask.bind(this);
    }

    componentDidMount() {
        this.loadTasks();
    }

    async toggleTaskStatus(task) {
        if (await this.saveTask(task)) {
            this.forceUpdate(); 
        }
    }

    async loadTasks() {
        this.setState({
            tasks: await this.getTasks()
        })
    }

    toggleAddTaskModal() {
        this.setState({
            isAddTaskOpen: !this.state.isAddTaskOpen
        });
    }  

    async addTask(description) {
        this.toggleAddTaskModal();
        var task = {
            description: description,
            completed: false
        };
        await this.saveTask(task);
        await this.loadTasks();
    }  

    async saveTask(task) {
        var res = null;
        if (task !== null && task.id != undefined) {
            res = await fetch(this.todo_api_url,{
                method: 'PUT',
                body: JSON.stringify(task),
                headers: {"Content-Type": "application/json"}
            });
            if (res.status === 200) {
                this.loadTasks();
            }
        }
        else {
            res = await fetch(this.todo_api_url,{
                method: 'POST',
                body: JSON.stringify(task),
                headers: {"Content-Type": "application/json"}
            });
        }

        if (res !== null && res.status === 200) {
            this.loadTasks();
            return true;
        }

        return false;
    }

    async deleteTask(id) {
        var res = await fetch(this.todo_api_url + '?id=' + id,{
                method: 'DELETE',
                headers: {"Content-Type": "application/json"}
            });

        if (res !== null && res.status === 200) {
            this.loadTasks();
            return true;
        }

        return false;
    }

    async getTasks() {
        const response = await fetch(this.todo_api_url);
        const body = await response.json();
        if (response.status !== 200) {
            throw Error(body.message) 
        }
        return body;
    }

    render() {
        return (
            <div>
                <div>
                    <div className="add-task">
                        <button onClick={this.toggleAddTaskModal}>Add New Task</button>
                    </div>
                    <Tasks tasks={this.state.tasks} toggleTaskStatus={this.toggleTaskStatus} deleteTask={this.deleteTask} />
                </div>
                <Modal 
                    isOpen={this.state.isAddTaskOpen}
                    onRequestClose={() => this.toggleAddTaskModal(false)}
                    className="modal"
                    overlayClassName="overlay">
                    <div>
                        <img src={close} className="modal-close" alt="close" onClick={() => this.toggleAddTaskModal(false)} />
                        <div className="modal-title">
                            <h3>Add Task</h3>
                        </div>
                        <div>
                            <AddTask handleSave={this.addTask} />
                        </div>
                    </div>
                </Modal>
            </div>
        );
    }
}