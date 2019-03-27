class Bird {
  constructor() {
    this.x = width / 2;
    this.y = height / 2;
    this.gravity = 0.6;
    this.lift = -15;
    this.velocity = 0;
    this.img = null;
  }

  show() {
    image(this.img, 0, 0);
  }

  up() {
    this.velocity += this.lift;
  }

  update() {
    this.velocity += this.gravity;
    this.velocity *= 0.9;
    this.y += this.velocity;

    if (this.y > height) {
      this.y = height;
      this.velocity = 0;
    }

    if (this.y < 0) {
      this.y = 0;
      this.velocity = 0;
    }
  }
}
