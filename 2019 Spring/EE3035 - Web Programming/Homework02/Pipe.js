class Pipe {
  constructor(pipe_upper, pipe_lower) {
    this.upperImg = pipe_upper;
    this.lowerImg = pipe_lower;
    this.height = 320;
    this.width = 52;
    this.gap = 200;
    this.upperTop = -Math.floor(Math.random() * (2 * this.height + this.gap - height));
    this.lowerTop = this.upperTop + this.height + this.gap;
    this.speed = 1;
    this.x = width;
  }

  show() {
    image(this.upperImg, this.x, this.upperTop);
    image(this.lowerImg, this.x, this.lowerTop);
  }

  update() {
    this.x -= this.speed;
  }

  offscreen() {
    if (this.x < -this.upperImg.width) return true;
    return false;
  }

  hits = bird => {
    if (bird.y < this.upperTop + this.height || bird.y > this.lowerTop)
      if (bird.x + 20 > this.x && bird.x + 20 < this.x + this.width) return true;
    return false;
  };
}
