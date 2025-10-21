class SpaceShip {
  // Member Variables
  int x, y, w, laserCount, turretCount, health;
  PImage ship;

  // Constructor
  SpaceShip() {
    x = width/2;
    y = height/2;
    w = 100;
    ship = loadImage("ship.png");
    laserCount = 1001;
    turretCount = 1;
    health = 500;
  }

  // Member Methods
  void display() {
    imageMode(CENTER);
    image(ship, x, y);
  }

  void move(int x, int y) {
    this.x = x;
    this.y = y;
  }

  boolean fire() {
    if(laserCount>0) {
      return true;
    } else {
      return false;
    }
  }

  boolean intersect(Rock r) {
  float d = dist(x, y, r.x, r.y);
    if(d<75) {
      return true;
    } else {
      return false;
    }
  }
}
