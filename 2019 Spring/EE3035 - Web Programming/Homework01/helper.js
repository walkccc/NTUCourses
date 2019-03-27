function toggleStyle(el, prop, ...styles) {
  el.style[prop] = el.style[prop] === styles[0] ? styles[1] : styles[0];
}

function compareTodo(a, b) {
  const aText = a.li.children[2].innerText.toUpperCase();
  const bText = b.li.children[2].innerText.toUpperCase();
  let result = aText.localeCompare(bText, 'en', { sensitivity: 'case' });
  return this.sortMode === 'Lexico' ? -result : result;
}

function display(option = currTab) {
  while (ul.firstChild) ul.removeChild(ul.firstChild);
  currTab = option;

  tabs.forEach(tab => {
    const tabButton = document.querySelector('#' + tab);
    tabButton.className = tab === currTab ? 'selected' : '';
  });

  if (option === 'all') {
    todos.forEach(todo => ul.appendChild(todo.li));
  } else if (option === 'active') {
    todos
      .filter(todo => !todo.isCompleted)
      .forEach(todo => ul.appendChild(todo.li));
  } else if (option === 'completed') {
    todos
      .filter(todo => todo.isCompleted)
      .forEach(todo => ul.appendChild(todo.li));
  }

  const counter = document.querySelector('#counter');
  const leftCount = todos.filter(todo => !todo.isCompleted).length;
  const doneCount = todos.filter(todo => todo.isCompleted).length;
  counter.innerHTML = `${leftCount} left / ${doneCount} done`;
}
