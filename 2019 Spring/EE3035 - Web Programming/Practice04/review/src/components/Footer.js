import React, {Component} from 'react';
import './Footer.css';

class Footer extends Component {
    render(){
        const totalCount = this.props.itemCount.toString() + 
            (this.props.itemCount == 1 ? " item left" : " items left");

        return(
            <footer className="todo-app__footer">
                <div className="todo-app__total">{totalCount}</div>
                <ul className="todo-app__view-buttons">
                    <button 
                        id="all" 
                        onClick={this.props.onChangeState}
                    >
                        All
                    </button>
                    <button 
                        id="active" 
                        onClick={this.props.onChangeState}
                    >
                        Active
                    </button>
                    <button 
                        id="completed" 
                        onClick={this.props.onChangeState}
                    >
                        Completed
                    </button>
                </ul>
                <div className="todo-app__clean">
                    <button
                        id="clear"
                        onClick={this.props.onClear}>
                        Clear completed
                    </button>
                </div>
            </footer>
        );
    }
}

export default Footer;

