SpaceShip fighter;
ArrayList bullets;

void setup () {
  size (1200,800);
  background(0);
  fighter = new SpaceShip();
  bullets = new ArrayList();
}

void draw () {
  background(0);

  fighter.update();
  fighter.draw();
  fighter.checkEdges();

  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = (Bullet) bullets.get(i);
    if (b.disappear) {
      bullets.remove(i);
    } else {
      b.update();
      b.checkEdges();
      b.draw();
    }
  }
}

class SpaceShip {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector thrust;
  PVector drag;

  float w, h;
  float scale;
  float mass;

  boolean thrusting = false;
  boolean teleporting = false;
  boolean shotBullet = false;

  float aVelocity = 0;
  float aAcceleration = 0;
  float theta = -PI/2;

  SpaceShip () {
    location = new PVector(width/2,height/2);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);

    thrust = new PVector(0,0);
    drag = new PVector(0,0);

    w = 9;
    h = 15;
    scale = 3;
    mass = scale * 10;
  }

  void applyForce (PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update () {
      if (checkKey("space") && !teleporting) {
        location.x = random(width);
        location.y = random(height);
        teleporting = true;
      }

      if (checkKey("shift") && !shotBullet) {
        shotBullet = true;
        PVector bulletDir = new PVector(cos(theta),sin(theta));
        bulletDir.mult(h/2*scale);
        PVector bulletLoc = PVector.add(bulletDir, location);
        bullets.add(new Bullet(bulletLoc, bulletDir));
      }

      if (!checkKey("shift") && shotBullet) {
        shotBullet = false;
      }

      if (!checkKey("space") && teleporting) {
        teleporting = false;
      }

      if (checkKey("left")) {
        theta -= 0.05;
      } else if (checkKey("right")) {
        theta += 0.05;
      }

      if (checkKey("up")) {
        thrusting = true;
        thrust = new PVector(cos(theta), sin(theta));
        thrust.mult(1.5);
        applyForce(thrust);
      } else {
        thrusting = false;
      }

    applyDrag();

    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void applyDrag () {
      if (velocity.mag() > 0) {
        drag = velocity.get();
        drag.normalize();
        drag.mult(-0.4);
        applyForce(drag);
      }
  }

  void checkEdges () {
    if (location.x < 0) {
      location.x += width;
    } else if (location.x > width) {
      location.x -= width;
    }

    if (location.y < 0) {
      location.y += height;
    } else if (location.y > height) {
      location.y -= height;
    }
  }

  void draw () {
    pushMatrix();
    translate(location.x, location.y);
    stroke(255);
    fill(255);
    rotate(theta);

    // hull
    triangle(-h/2*scale,-w/2*scale,
             -h/2*scale,w/2*scale,
             h/2*scale,0);

    if (thrusting) {
      noStroke();
      fill(255,0,0);
      // left side triangle
      triangle(-h/2*scale-1,-w/4*scale-2*scale,
               -h/2*scale-1,-w/4*scale+2*scale,
               -h/2*scale-random(1,3)*scale, -w/4*scale);
      // right side triangle
      triangle(-h/2*scale-1,w/4*scale-2*scale,
               -h/2*scale-1,w/4*scale+2*scale,
               -h/2*scale-random(1,3)*scale, w/4*scale);
    }

    popMatrix();
  }
}

class Bullet {
  PVector location;
  PVector velocity;

  boolean disappear = false;
  float distanceTraveled = 0;
  float disappearDistance;
  float w, h;
  float scale;

  Bullet (PVector loc, PVector dir) {
    location = loc.get();
    velocity = dir;
    velocity.normalize();
    velocity.mult(10);

    w = h = 2;
    scale = 2;
    disappearDistance = width/3;
  }

  void update () {
    distanceTraveled += velocity.mag();

    if (distanceTraveled > disappearDistance) {
      disappear = true;
    }

    location.add(velocity);
  }

  void checkEdges() {
    if (location.x < 0) {
      location.x += width;
    } else if (location.x > width) {
      location.x -= width;
    }

    if (location.y < 0) {
      location.y += height;
    } else if (location.y > height) {
      location.y -= height;
    }
  }

  void draw () {
    pushMatrix();
    fill(255);
    noStroke();
    rect(location.x-w/2*scale, location.y-h/2*scale, w*scale, h*scale);
    popMatrix();
  }
}
