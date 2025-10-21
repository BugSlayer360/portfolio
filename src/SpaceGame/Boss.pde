class Boss {
  // Member Variables
  int x, w, health;
  float speed, y;
  PImage boss;

  // Constructor
  Boss() {
    x = 960;
    y = -200;
    speed = 1;
    w = 500;
    health = 190;
    boss = loadImage("patrick.png");
  }

  // Member Methods
  void display() {
    imageMode(CENTER);
    boss.resize(w, w);
    image(boss, x, y);
    rectMode(CORNER);
    fill(255);
    rect(x-110,y+295,200,25);
    fill(255, 0, 0);
    rect(x-105,y+297.2,health,19);
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
