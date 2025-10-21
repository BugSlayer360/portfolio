class Rock {
  // Member Variables
  int x, y, w, speed;
  PImage r1;

  // Constructor
  Rock() {
    x = int(random(width));
    y = -300;
    w = int(random(50, 100));
    speed = int(random(1, 10));

    //Choosing which graphic
    if (random(10)>7) {
      r1 = loadImage("rock01.png");
    } else if (random(10)>5) {
      r1 = loadImage("amongus.png");
    } else {
      r1 = loadImage("spaceShip.gif");
    }
  }

  // Member Methods
  void display() {
    imageMode(CENTER);
    if(w<1) {
      w = 10;
    }
    r1.resize(w, w);
    image(r1, x, y);
  }

  void move() {
    y = y + speed;
  }

  boolean reachedBottom() {
    if (y>height+w) {
      return true;
    } else {
      return false;
    }
  }
}
