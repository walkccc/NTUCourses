const prevBtn = document.querySelector('#prevBtn');
const nextBtn = document.querySelector('#nextBtn');
const images = [
  'https://images.unsplash.com/photo-1520177039695-1752e4458785?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523396065099-5121c73ea1f7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2250&q=80',
  'https://images.unsplash.com/photo-1483396828226-99033d93e447?ixlib=rb-1.2.1&auto=format&fit=crop&w=1959&q=80'
];  // using 4K image to see the "loading" effect
let curr = 0;
let img = document.querySelector('#img');
let message = document.querySelector('#message');

loadingImage();
prevBtn.classList.add('disabled');

function prev() {
  if (curr !== 0) {
    curr--;
    afterClicked();
  }
}

function next() {
  if (curr !== images.length - 1) {
    curr++;
    afterClicked();
  }
}

function loadingImage() {
  img.src = './images/loading.gif';
  var loading = new Image();
  loading.onload = function() {
    img.src = this.src;
  };
  loading.src = images[curr];
  message.innerHTML = 'Source: ' + images[curr];
}

function afterClicked() {
  loadingImage();
  curr === 0 ? 
    prevBtn.classList.add('disabled') :
    prevBtn.classList.remove('disabled');

  curr === images.length - 1 ?
    nextBtn.classList.add('disabled') :
    nextBtn.classList.remove('disabled');
}
