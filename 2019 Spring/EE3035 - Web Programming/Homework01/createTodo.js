function createTodo(val) {
  const li = document.createElement('li');
  const wrapper = document.createElement('div');
  const checkbox = document.createElement('input');
  const label = document.createElement('label');
  const input = document.createElement('input');
  const h1 = document.createElement('h1');
  const deleteButton = document.createElement('img');
  const editButton = document.createElement('img');

  li.className = 'todo-app__item';
  wrapper.className = 'todo-app__checkbox';
  checkbox.type = 'checkbox';
  checkbox.id = ++id;
  label.setAttribute('for', id);
  input.type = 'text';

  h1.className = 'todo-app__item-detail';
  h1.id = id;
  h1.innerText = val;

  deleteButton.className = 'todo-app__item-icon';
  deleteButton.src = './img/x.png';
  deleteButton.alt = 'delete';
  deleteButton.id = 'delete';

  editButton.className = 'todo-app__item-icon';
  editButton.src = './img/edit.png';
  editButton.alt = 'edit';
  editButton.id = 'edit';

  wrapper.appendChild(checkbox);
  wrapper.appendChild(label);

  li.appendChild(wrapper);
  li.appendChild(input);
  li.appendChild(h1);
  li.appendChild(editButton);
  li.appendChild(deleteButton);

  return li;
}
