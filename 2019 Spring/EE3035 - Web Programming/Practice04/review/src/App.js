import React, { Component } from 'react';
import './App.css';

import Header from './components/Header';
import Main from './components/Main';
import Footer from './components/Footer';

function itemNode(id, content){
	this.id = id;
	this.content = content;
	this.done = false;
}

class App extends Component {
	constructor(props){
		super(props);
		this.state = {
			todoItems: [],
			currId: 0,
			renderState: 'all',
		};
	}

	addTodoItem = item => {
		const newItems = this.state.todoItems;
		let newItem = new itemNode(this.state.currId, item);
		newItems.push(newItem);
		this.setState(state => ({
			todoItems: newItems,
			currId: state.currId + 1
		}));
	}
	
	onUserInput = e => {
		if (e.key === "Enter") {
			const value = e.target.value;
			if (value) this.addTodoItem(value);
			e.target.value = "";
			e.target.blur();
			//console.log(this.state.todoItems);
		}
	}

	
	onDeleteItem = e => {
		const todoIdx = this.state.todoItems.findIndex(item => item.id == e.target.id);
		const newTodoItems = this.state.todoItems;
		//console.log(this.state.todoItems);
		newTodoItems.splice(todoIdx, 1);
		this.setState(state => ({
				todoItems: newTodoItems,
			})
		)
	}

	onMarkItem = e => {
		const idx = this.state.todoItems.findIndex(item => item.id == e.target.id);
		const newItems = this.state.todoItems;
		newItems[idx].done = !newItems[idx].done;
		this.setState(state => ({
				todoItems: newItems,
			})
		)
		//console.log(this.state.todoItems);
	}
	
	onChangeState = e => {
		const newRenderState = e.target.id;
		this.setState(state => ({
				renderState: newRenderState,
			})
		)
	}

	onClear = e => {
		const newTodoItems = this.state.todoItems.filter(item => !item.done);
		this.setState(state => ({
				todoItems: newTodoItems,
			})
		)
	}

	getRenderItems = () => {
		let renderItems;
		if(this.state.renderState == 'all') renderItems = this.state.todoItems;
		else if(this.state.renderState == 'active') renderItems = this.state.todoItems.filter(item => !item.done);
		else if(this.state.renderState == 'completed') renderItems = this.state.todoItems.filter(item => item.done);
		return renderItems;
	}

	render() {
		return (
				<div className="todo-app__root">
					<Header title="todos" />
					<Main 
						items={this.getRenderItems()} 
						onUserInput={this.onUserInput} 
						onDeleteItem={this.onDeleteItem}
						onMarkItem={this.onMarkItem}
					/>
					<Footer 
						itemCount={this.state.todoItems.filter(item => !item.done).length}
						onChangeState={this.onChangeState}
						onClear={this.onClear}
					/>
				</div>
			);
		}
}

export default App;
