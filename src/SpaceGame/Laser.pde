class Laser {
  // Member Variables
  int x, y, w, h, speed;
  PImage laser;

  // Constructor
  Laser(int x, int y) {
    this.x = x;
    this.y = y;
    w = 70;
    h = 70;
    speed = 5;
    laser = loadImage("laser.png");
  }

  // Member Methods
  void display() {
    imageMode(CENTER);
    image(laser, x, y-40, w, h);
  }

  void move() {
    y = y - speed;
  }

  boolean reachedTop() {
    if (y<-30) {
      return true;
    } else {
      return false;
    }
  }

  boolean intersect(Rock r) {
    float d1 = dist(x, y, r.x, r.y);
    if(d1<50) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean intersect(Boss b) {
    float d2 = dist(x, y, b.x, b.y);
    if(d2<200) {
      return true;
    } else {
      return false;
    }
  }
}
