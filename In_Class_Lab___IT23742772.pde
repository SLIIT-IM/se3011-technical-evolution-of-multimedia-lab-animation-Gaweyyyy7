int state = 0;

float px, py;
float pr = 20;
float step = 6;

float ox, oy, xs, ys;
float ox2, oy2, xs2, ys2;
float orr = 15;

float goldX, goldY;
boolean goldActive = false;
int goldTimer = 0;

float hx, hy;
float ease = 0.09;

boolean trails = false;

int score = 0;
int startTime;
int duration = 30;

void setup() {
  size(720, 420);
  resetGame();
}

void draw() {

  if (!trails || state != 1) {
    background(250);
  } else {
    fill(250, 30);
    rect(0, 0, width, height);
  }

  if (state == 0) {
    textAlign(CENTER, CENTER);
    textSize(28);
    fill(0);
    text("Orbit Hunter", width/2, height/2 - 30);
    textSize(18);
    text("Press ENTER to Begin", width/2, height/2 + 20);
  }

  if (state == 1) {

    int elapsed = (millis() - startTime) / 1000;
    int left = duration - elapsed;
    if (left <= 0) state = 2;

    if (keyPressed) {
      if (keyCode == RIGHT) px += step;
      if (keyCode == LEFT)  px -= step;
      if (keyCode == DOWN)  py += step;
      if (keyCode == UP)    py -= step;
    }

    px = constrain(px, pr, width - pr);
    py = constrain(py, pr, height - pr);

    moveOrb();
    moveOrb2();
    handleGold();

    hx += (px - hx) * ease;
    hy += (py - hy) * ease;

    fill(255, 90, 90);
    ellipse(ox, oy, orr*2, orr*2);

    fill(120, 90, 255);
    ellipse(ox2, oy2, orr*2, orr*2);

    if (goldActive) {
      fill(255, 200, 0);
      ellipse(goldX, goldY, orr*2, orr*2);
    }

    fill(40, 120, 200);
    ellipse(px, py, pr*2, pr*2);

    fill(60, 200, 140);
    ellipse(hx, hy, 12, 12);

    fill(0);
    textAlign(LEFT, TOP);
    text("Score: " + score, 20, 20);
    text("Time: " + left, 20, 40);
  }

  if (state == 2) {
    textAlign(CENTER, CENTER);
    textSize(26);
    fill(0);
    text("Game Over", width/2, height/2 - 20);
    text("Final Score: " + score, width/2, height/2 + 10);
    text("Press R to Restart", width/2, height/2 + 40);
  }
}

void moveOrb() {
  ox += xs;
  oy += ys;

  if (ox < orr || ox > width - orr) xs *= -1;
  if (oy < orr || oy > height - orr) ys *= -1;

  if (dist(px, py, ox, oy) < pr + orr) {
    score++;
    xs *= 1.07;
    ys *= 1.07;
    ox = random(orr, width - orr);
    oy = random(orr, height - orr);
  }
}

void moveOrb2() {
  ox2 += xs2;
  oy2 += ys2;

  if (ox2 < orr || ox2 > width - orr) xs2 *= -1;
  if (oy2 < orr || oy2 > height - orr) ys2 *= -1;

  if (dist(px, py, ox2, oy2) < pr + orr) {
    score++;
    ox2 = random(orr, width - orr);
    oy2 = random(orr, height - orr);
  }
}

void handleGold() {

  if (score > 0 && score % 5 == 0 && !goldActive) {
    goldX = random(orr, width - orr);
    goldY = random(orr, height - orr);
    goldActive = true;
    goldTimer = millis();
  }

  if (goldActive && millis() - goldTimer > 3000) {
    goldActive = false;
  }

  if (goldActive && dist(px, py, goldX, goldY) < pr + orr) {
    score += 3;
    goldActive = false;
  }
}

void keyPressed() {

  if (state == 0 && keyCode == ENTER) {
    state = 1;
    startTime = millis();
  }

  if (state == 2 && (key == 'r' || key == 'R')) {
    resetGame();
    state = 0;
  }

  if (key == 't' || key == 'T') {
    trails = !trails;
  }
}

void resetGame() {
  px = width/2;
  py = height/2;
  hx = px;
  hy = py;

  score = 0;
  goldActive = false;

  ox = random(orr, width - orr);
  oy = random(orr, height - orr);
  xs = random(3, 5);
  ys = random(2, 4);

  ox2 = random(orr, width - orr);
  oy2 = random(orr, height - orr);
  xs2 = random(2, 4);
  ys2 = random(3, 5);
}
