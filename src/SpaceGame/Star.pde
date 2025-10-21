class Star {
  // Member Variables
  int x, y, w, speed;
  Star() {
    x = int(random(width));
    y = -10;
    w = int(random(1, 4));
    speed = int(random(2, 8));
  }

  // Member Methods

  void display() {
      fill(random(225, 255));
      ellipse(x, y, w, w);
      if(random(1)<0.0005) {
      }
    } 
    
  


  void move() {
    y = y + speed;
  }

  boolean reachedBottom() {
    if (y>height+10) {
      return true;
    } else {
      return false;
    }
  }
}
