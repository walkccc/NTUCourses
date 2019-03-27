let bg_day = new Image();
let bg_night = new Image();

let base = new Image();
let message = new Image();
let gameOver = new Image();

let wing = new Audio();
let point = new Audio();
let hit = new Audio();
let die = new Audio();

let color = ['red', 'blue', 'yellow'];
let flap = ['down', 'mid', 'up'];
let birds = [];

let allPipes = [];
let pipesPath = [
  'assets/sprites/pipe-green-upper.png',
  'assets/sprites/pipe-green-lower.png',
  'assets/sprites/pipe-red-upper.png',
  'assets/sprites/pipe-red-lower.png'
];

// assets from: https://github.com/sourabhv/FlapPyBird/tree/master/assets
function preload() {
  bg_day = loadImage('assets/sprites/background-day.png');
  bg_night = loadImage('assets/sprites/background-night.png');

  base = loadImage('assets/sprites/base.png');
  message = loadImage('assets/sprites/message.png');
  gameOver = loadImage('assets/sprites/gameover.png');

  wing = loadSound('assets/audio/wing.wav');
  point = loadSound('assets/audio/point.wav');
  hit = loadSound('assets/audio/hit.wav');
  die = loadSound('assets/audio/die.wav');

  for (let i = 0; i < color.length; i++)
    for (let j = 0; j < flap.length; j++)
      birds.push(loadImage(`assets/sprites/${color[i]}bird-${flap[j]}flap.png`));

  for (let i = 0; i < pipesPath.length; i++) allPipes.push(loadImage(pipesPath[i]));
}

let score = 0;
let bird;
let bg;
let randBirds = [];
let randPipes = [];
let pipeSelector = 0;

function setup() {
  let cvsWrapper = document.getElementById('canvasWrapper');
  const myCanvas = createCanvas(cvsWrapper.offsetWidth, cvsWrapper.offsetHeight);
  myCanvas.parent('canvasWrapper');

  bird = new Bird();
  randBirds = [];

  pipes = [];
  score = 0;

  if (Math.round(Math.random())) bg = bg_day;
  else bg = bg_night;

  pipeSelector = Math.round(Math.random());

  let birdSelector = Math.floor(3 * Math.random());
  for (let i = birdSelector * 3; i < birdSelector * 3 + 3; i++) randBirds.push(birds[i]);

  angleMode(DEGREES);
}

let angle = 0;
let isStart = false;
let isStop = false;
let x = 0;

function draw() {
  if (x < -width) x = 0;
  if (frameCount % 200 === 0)
    pipes.push(new Pipe(allPipes[pipeSelector * 2], allPipes[pipeSelector * 2 + 1]));

  image(bg, x, 0, width, height);
  image(bg, x + width, 0, width, height);
  x--;

  if (isStop) image(gameOver, width / 2 - gameOver.width / 2, 100);
  if (!isStart) image(message, 0, 0, width, height);

  if (isStart && !isStop) {
    for (let i = pipes.length - 1; i >= 0; i--) {
      pipes[i].show();
      pipes[i].update();

      if (pipes[i].hits(bird)) gg();
      if (pipes[i].offscreen()) pipes.splice(i, 1);

      if (Math.floor(pipes[i].x) == width / 2 - 20) {
        score++;
        point.play();
      }
    }

    let scoreStr = score.toString();

    for (let i = 0; i < scoreStr.length; i++) {
      let scoreImg = createImg(`assets/sprites/${scoreStr[i]}.png`);
      image(scoreImg, width / 2 + i * 20, 20);
    }

    if (bird.y > height - base.height || bird.y < 5) gg();
    image(base, 0, height - base.height, width);

    translate(bird.x, bird.y);
    rotate(angle * 0.5);
    angle++;

    if (frameCount % 3 === 0) {
      bird.img = randBirds[0];
    } else if (frameCount % 3 === 1) {
      bird.img = randBirds[1];
    } else {
      bird.img = randBirds[2];
    }

    bird.show();
    bird.update();
  }
}

function gg() {
  isStop = true;
  hit.play();
  die.play();
}

const fly = () => {
  wing.play();
  bird.up();
  angle = -45;
};

function keyPressed() {
  if (key === ' ') {
    if (!isStop) {
      isStart = true;
      fly();
    } else {
      isStart = true;
      isStop = false;
      setup();
    }
  }
}
