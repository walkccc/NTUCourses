const tabs = ['all', 'active', 'completed'];
const input = document.querySelector('#todo-input');
const sortButton = document.querySelector('#sort');
const clearButton = document.querySelector('#clear');
const ul = document.querySelector('#todo-list');

let currTab = '';
let id = -1;
let todos = [];

tabs.forEach(tab => {
  const tabButton = document.querySelector('#' + tab);
  tabButton.addEventListener('click', () => display(tab));
});

input.addEventListener('keypress', key => {
  if (key.which === 13 && input.value !== '') {
    const li = createTodo(input.value);
    const newTodo = { li, id, isCompleted: false };
    todos.push(newTodo);
    bindTask(newTodo);
    display('all');
    input.value = '';
  }
});

sortButton.addEventListener('click', () => {
  todos.sort(compareTodo);
  display();
});

clearButton.addEventListener('click', () => {
  todos = todos.filter(todo => !todo.isCompleted);
  display();
});

const bindTask = function(todo) {
  const id = todo.id;
  const checkbox = todo.li.querySelector('input[type=checkbox]');
  const h1 = todo.li.querySelector('h1');
  const editButton = todo.li.querySelector('#edit');
  const deleteButton = todo.li.querySelector('#delete');

  checkbox.addEventListener('click', () => {
    toggleStyle(h1, 'textDecoration', 'line-through', 'none');
    toggleStyle(h1, 'opacity', '0.5', '1.0');
    todo.isCompleted = !todo.isCompleted;
    display();
  });

  editButton.addEventListener('click', () => {
    const input = todo.li.querySelector('input[type=text]');
    toggleStyle(h1, 'display', '', 'none');

    if (todo.li.classList.contains('edit-mode')) {
      h1.innerText = input.value;
    } else {
      input.value = h1.innerText;
      input.addEventListener('keypress', keyPressed => {
        if (keyPressed.which === 13 && input.value !== '') {
          h1.innerText = input.value;
          toggleStyle(h1, 'display', '', 'none');
          todo.li.classList.toggle('edit-mode');
          display();
          input.value = '';
        }
      });
    }
    todo.li.classList.toggle('edit-mode');
  });

  deleteButton.addEventListener('click', () => {
    todos = todos.filter(todo => todo.id !== id);
    display();
  });
};
