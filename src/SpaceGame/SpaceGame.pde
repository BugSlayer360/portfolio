// Ender Hale | September 23 2025 | SpaceGame
SpaceShip s1;
Rock r1;
import processing.sound.*;
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<PowerUp> powups = new ArrayList<PowerUp>();
ArrayList<Boss> bosses = new ArrayList<Boss>();
Timer rockTimer;
Timer puTimer;
Timer levelTimer;
int score, rocksPassed, level, levelTime, rtime;
boolean gameOver, start, bossLevel, bossSpawned;
PImage startScreen, explosion;
SoundFile boom;
SoundFile shoot;
SoundFile gling;

void setup() {
  fullScreen();
  background(22);
  frameRate(80);
  s1 = new SpaceShip();
  r1 = new Rock();
  score = 0;
  rocksPassed = 0;
  level = 1;
  bossLevel = false;

  // Timers
  levelTime = 15000;
  rtime = 800;
  rockTimer = new Timer(rtime);
  rockTimer.start();
  puTimer = new Timer(5000);
  puTimer.start();
  levelTimer = new Timer(levelTime);
  levelTimer.start();
  gameOver = false;
  start = false;
  startScreen = loadImage("StartScreen.png");
  explosion = loadImage("boom.png");
  boom = new SoundFile(this, "BoomSound.wav");
  shoot = new SoundFile(this, "shoot.wav");
  gling = new SoundFile(this, "powerup.wav");
}

void draw() {
  if (!start) {
    startScreen();
  } else {
    background(0);

    //Check For Spawning bosses
    if ((level == 3 || level == 5 || level == 7 || level == 10)&& !bossSpawned) {
      //Spawning
      bossLevel = true;
      bosses.clear();
      rocks.clear();
      powups.clear();
      bosses.add(new Boss());
      bossSpawned = true;
      levelTimer.stop();
    }


    // Distributes a powerup on a timer
    if (!bossLevel && puTimer.isFinished()) {
      powups.add(new PowerUp());
      puTimer.start();
    }

    // Display and move all powerups
    for (int i = 0; i < powups.size(); i++) {
      PowerUp pu = powups.get(i);
      pu.display();
      pu.move();

      if (pu.intersect(s1)) {
        powups.remove(pu);
        gling.play();
        if (pu.type == 'H') {
          s1.health += int(random(100, 200));
        } else if (pu.type == 'T') {
          s1.turretCount++;
        } else if (pu.type == 'A') {
          s1.laserCount += int(random(100, 300));
        }
        i--;
      }

      if (pu.reachedBottom()) {
        powups.remove(pu);
        i--;
      }
    }

    // Add Stars
    stars.add(new Star());

    // Distribute rocks on a timer
    if (!bossLevel && rockTimer.isFinished()) {
      rocks.add(new Rock());
      rockTimer.start();
    }

    // Display Stars
    for (int i = 0; i < stars.size(); i++) {
      Star star = stars.get(i);
      star.display();
      star.move();
      if (star.reachedBottom()) {
        stars.remove(star);
        i--;
      }
    }

    // Display and move Rocks
    for (int i = 0; i < rocks.size(); i++) {
      Rock rock = rocks.get(i);

      if (s1.intersect(rock)) {
        s1.health -= rock.w;
        if (s1.health < 1) gameOver = true;
        rocks.remove(rock);
        score += rock.w;
        i--;
        continue;
      }

      rock.display();
      rock.move();
      if (rock.reachedBottom()) {
        rocks.remove(rock);
        rocksPassed++;
        i--;
      }
    }

    // Display Bosses
    for (int i = 0; i < bosses.size(); i++) {
      Boss boss = bosses.get(i);
      boss.display();
      boss.move();

      if (boss.health <= 0) {
        bosses.remove(i);
        i--;
        bossLevel = false;
        score += 10000;
        level += 1;
        bossSpawned = false;
      }

      if (boss.reachedBottom()) {
        bosses.remove(boss);
        gameOver = true;
        bossLevel = false;
        i--;
      }
    }

    // Display and remove lasers
    for (int i = 0; i < lasers.size(); i++) {
      Laser laser = lasers.get(i);
      laser.display();
      laser.move();

      // Rock Collision
      for (int j = 0; j < rocks.size(); j++) {
        Rock r = rocks.get(j);
        if (laser.intersect(r)) {
          r.w -= 30;
          if (r.w < 5) {
            rocks.remove(j);
            j--;
            score += 50;
            s1.laserCount += 5;
          }
          lasers.remove(i);
          i--;
          break;
        }
      }

      // Boss Collision
      for (int j = 0; j < bosses.size(); j++) {
        Boss b = bosses.get(j);
        if (laser.intersect(b)) {
          b.health -= 3;
          lasers.remove(i);
          i--;
          if (b.health <= 0) {
            bosses.remove(j);
            j--;
            score += 10000;
            level++;
            levelTimer.start();
          }
          break;
        }
      }

      if (i >= 0 && laser.reachedTop()) {
        lasers.remove(i);
        i--;
      }
    }

    // Player display and movement
    s1.display();
    s1.move(mouseX, mouseY);


    infoPanel();




    // Game over checks
    if (gameOver || rocksPassed > 10) {
      gameOver();
    }




    if (bossLevel==true) {
      fill(225, 0, 0);
      text("BOSS LEVEL! SPAM CLICK!", width-175, height-height+60);
    }


    if (bosses.isEmpty()) {
      bossLevel = false;
    }


    // Level timer
    if (levelTimer.isFinished()) {
      level++;
      rtime -= 1000;
      levelTimer.start();
      rocks.clear();
      lasers.clear();
      powups.clear();
      rocksPassed = 0;
      rockTimer.start();
      puTimer.start();
    }
  }
}

void mousePressed() {
  if (!s1.fire()) return;

  s1.laserCount--;
  if (!gameOver) shoot.play();

  if (s1.turretCount == 1) {
    lasers.add(new Laser(s1.x, s1.y - 40));
  } else if (s1.turretCount == 2) {
    lasers.add(new Laser(s1.x - 30, s1.y - 40));
    lasers.add(new Laser(s1.x + 30, s1.y - 40));
  } else if (s1.turretCount == 3) {
    lasers.add(new Laser(s1.x - 50, s1.y - 40));
    lasers.add(new Laser(s1.x, s1.y - 40));
    lasers.add(new Laser(s1.x + 50, s1.y - 40));
  } else if (s1.turretCount == 4) {
    lasers.add(new Laser(s1.x - 65, s1.y - 40));
    lasers.add(new Laser(s1.x - 25, s1.y - 40));
    lasers.add(new Laser(s1.x + 25, s1.y - 40));
    lasers.add(new Laser(s1.x + 65, s1.y - 40));
  } else if (s1.turretCount == 5) {
    lasers.add(new Laser(s1.x - 100, s1.y - 40));
    lasers.add(new Laser(s1.x - 50, s1.y - 40));
    lasers.add(new Laser(s1.x, s1.y - 40));
    lasers.add(new Laser(s1.x + 50, s1.y - 40));
    lasers.add(new Laser(s1.x + 100, s1.y - 40));
  } else if (s1.turretCount == 6) {
    lasers.add(new Laser(s1.x - 125, s1.y - 40));
    lasers.add(new Laser(s1.x - 75, s1.y - 40));
    lasers.add(new Laser(s1.x - 25, s1.y - 40));
    lasers.add(new Laser(s1.x + 25, s1.y - 40));
    lasers.add(new Laser(s1.x + 75, s1.y - 40));
    lasers.add(new Laser(s1.x + 125, s1.y - 40));
  } else if (s1.turretCount == 7) {
    lasers.add(new Laser(s1.x - 150, s1.y - 40));
    lasers.add(new Laser(s1.x - 100, s1.y - 40));
    lasers.add(new Laser(s1.x - 50, s1.y - 40));
    lasers.add(new Laser(s1.x, s1.y - 40));
    lasers.add(new Laser(s1.x + 50, s1.y - 40));
    lasers.add(new Laser(s1.x + 100, s1.y - 40));
    lasers.add(new Laser(s1.x + 150, s1.y - 40));
  } else if (s1.turretCount == 8) {
    lasers.add(new Laser(s1.x - 175, s1.y - 40));
    lasers.add(new Laser(s1.x - 125, s1.y - 40));
    lasers.add(new Laser(s1.x - 75, s1.y - 40));
    lasers.add(new Laser(s1.x - 25, s1.y - 40));
    lasers.add(new Laser(s1.x + 25, s1.y - 40));
    lasers.add(new Laser(s1.x + 75, s1.y - 40));
    lasers.add(new Laser(s1.x + 125, s1.y - 40));
    lasers.add(new Laser(s1.x + 175, s1.y - 40));
  } else if (s1.turretCount == 9) {
    lasers.add(new Laser(s1.x - 200, s1.y - 40));
    lasers.add(new Laser(s1.x - 150, s1.y - 40));
    lasers.add(new Laser(s1.x - 100, s1.y - 40));
    lasers.add(new Laser(s1.x - 50, s1.y - 40));
    lasers.add(new Laser(s1.x, s1.y - 40));
    lasers.add(new Laser(s1.x + 50, s1.y - 40));
    lasers.add(new Laser(s1.x + 100, s1.y - 40));
    lasers.add(new Laser(s1.x + 150, s1.y - 40));
    lasers.add(new Laser(s1.x + 200, s1.y - 40));
  } else if (s1.turretCount == 10) {
    lasers.add(new Laser(s1.x - 225, s1.y - 40));
    lasers.add(new Laser(s1.x - 175, s1.y - 40));
    lasers.add(new Laser(s1.x - 125, s1.y - 40));
    lasers.add(new Laser(s1.x - 75, s1.y - 40));
    lasers.add(new Laser(s1.x -25, s1.y - 40));
    lasers.add(new Laser(s1.x + 25, s1.y - 40));
    lasers.add(new Laser(s1.x + 75, s1.y - 40));
    lasers.add(new Laser(s1.x + 125, s1.y - 40));
    lasers.add(new Laser(s1.x + 175, s1.y - 40));
    lasers.add(new Laser(s1.x + 225, s1.y - 40));
  }
}
  void infoPanel() {
    rectMode(CENTER);
    fill(127, 127);
    rect(width / 2, height-30, width, 50);
    fill(220);
    textSize(25);
    text("Score: " + score, 60, height - 30);
    text("Rocks Passed: " + rocksPassed, width - 175, height - 30);
    text("Health: " + s1.health, (width / 2)/2, height-30);
    text("Ammo: " + s1.laserCount, width / 2, height-30);
    text("Turrets: " + s1.turretCount, (width / 2)+((width/2)/2), height-30);
    fill(225);
    text("Level: " + level, 60, height-height+60);
    rectMode(CORNER);
    fill(255);
    rect(s1.x - 50, s1.y + 50, 100, 12);
    fill(255, 0, 0);
    rect(s1.x - 45, s1.y + 52, s1.health / 5.5, 7);
  }

  void gameOver() {
    background(0);
    boom.play();
    image(explosion, s1.x, s1.y);
    fill(255);
    textSize(50);
    text("Game Over", width / 2, height / 2 - 20);
    textSize(30);
    text("You Received A Score Of:", width / 2, height / 2 + 50);
    text(score, width / 2 + 190, height / 2 + 50);
    noLoop();
  }

  void startScreen() {
    imageMode(CENTER);
    startScreen.resize(1920,1080);
    image(startScreen, width / 2, height / 2);
    textAlign(CENTER, CENTER);
    textSize(50);
    text("Space Game", width / 2, height / 2 - 40);
    textSize(20);
    text("Click Mouse To Start", width / 2, height / 2 + 20);
    if (mousePressed) start = true;
  }
