/* @pjs pauseOnBlur="true"; */
/* @pjs globalKeyEvents="true"; */ 

int snakeX = 1440/2;
int snakeY = 900/2;
int foodX = 50;
int foodY = 50;
int pix = 36;
int stat = 4;
int frameDelay = 5;
int frameModCount = 0;
boolean notEnd = true;
float statOver2 = stat/2;
IntList snake;
int k = 0;
int toggle = 0; 
int j = 0;
int collide = 0;
int statChange = 0;
int doubleMove = 0;
boolean checkTrue = false;
float fontSizeZoom = 0; 

void setup() {
  frameRate(60);
  pixelDensity(1);
  size(1440, 825);
  snakeY = height/2;
  snakeX = width/2;
  background(0); 
  smooth();
  fill(255, 250, 240);
  textSize(150);
  textAlign(CENTER, CENTER);
  text("Loading...", width/2, height/2);
  snake = new IntList();
  snake.append(snakeX);
  snake.append(snakeY);
  placeFood();
  checkFood();
}

void snake() {
  j = 90;
  fill(((sin(j)+1)/2)*255, ((sin(j*1.2)+1)/2)*255, ((sin(j*1.5)+1)/2)*255);
  rect(snakeX, height-snakeY, pix, pix, 15);
  if (snake.size()>2) {
    for (int i=0; i<(snake.size()/2); i++) {
      fill(((sin(j)+2)/3)*255, ((sin(j*1.2)+2)/3)*255, ((sin(j*1.5)+2)/3)*255);
      j += 1;
      k = (i*2);
      rect(snake.get(k+0), height-(snake.get(k+1)), pix, pix, 15);
      fill(((sin(j*1.2)+1)/2)*255, ((sin(j*1.5)+1)/2)*255, ((sin(j)+1)/2)*255);
      rect(snake.get(k+0)+pix/3, height-(snake.get(k+1))+pix/3, pix/3, pix/3);
    }
  }
}

void food() {
  fill(255, 150, 100); 
  rect(foodX, height-foodY, pix, pix, 15);
}

void move() {
  if (doubleMove == 0) {
    snakeY += pix;
    doubleMove = 11;
  }
  if (doubleMove == 1) {
    snakeX += pix;
    doubleMove = 11;
  }
  if (doubleMove == 2) {
    snakeY -= pix;
    doubleMove = 11;
  }
  if (doubleMove == 3) {
    snakeX -= pix;
    doubleMove = 11;
  }
  if (stat == 0) {
    snakeY += pix;
  }
  if (stat == 1) {
    snakeX += pix;
  }
  if (stat == 2) {
    snakeY -= pix;
  }
  if (stat == 3) {
    snakeX -= pix;
  }
  snake.set(0, snakeX);
  snake.set(1, snakeY);
}

void keyPressed() {
  if (statChange != stat) {
    doubleMove = stat;
  } else {
    doubleMove = 11;
  }
  statOver2 = float(stat)/2;
  if (key == 'w' || key == 'W') {
    if (statOver2 != round(statOver2)) {
      stat = 0;
    }
    if (stat == 4) {
      stat = 0;
    }
  }
  if (key == 'd' || key == 'D') {
    if (statOver2 == round(statOver2)) {
      stat = 1;
    }
  }
  if (key == 's' || key == 'S') {
    if (statOver2 != round(statOver2)) {
      stat = 2;
    }
    if (stat == 4) {
      stat = 2;
    }
  }
  if (key == 'a' || key == 'A') {
    if (statOver2 == round(statOver2)) {
      stat = 3;
    }
  }
  if (key == CODED) {
    if (keyCode == UP) {
      if (statOver2 != round(statOver2)) {
        stat = 0;
      }
      if (stat == 4) {
        stat = 0;
      }
    }
    if (keyCode == RIGHT) {
      if (statOver2 == round(statOver2)) {
        stat = 1;
      }
    }
    if (keyCode == DOWN) {
      if (statOver2 != round(statOver2)) {
        stat = 2;
      }
      if (stat == 4) {
        stat = 2;
      }
    }
    if (keyCode == LEFT) {
      if (statOver2 == round(statOver2)) {
        stat = 3;
      }
    }
  }
}

void placeFood() {
  foodX = int(random(int(width/pix))-1)*pix; 
  foodY = int(random(int(height/pix))-2)*pix; 
  foodX += pix;
  foodY += pix/2;
}

void getFood() {
  if (toggle == 0) {
    snake.append(foodX);
    snake.append(foodY);
    placeFood();
    collide = 2;
  }
  toggle = 1;
}

void checkFood() {
  checkTrue = true; 
  if (foodX<0 || foodX>width) {
    foodX = int(random(int(width/pix))-1)*pix; 
    foodX += pix;
    checkFood();
  } else {
    checkTrue = false;
  }
  if (foodY<0 || foodY>height) {
    foodY = int(random(int(height/pix))-2)*pix; 
    foodY += pix/2;
    checkFood();
  } else {
    checkTrue = false;
  }
  if (checkTrue) {
    if (snake.size()>2) {
      for (int i=0; i<(snake.size()); i+=2) {
        if (snake.get(i) == foodX) {
          if (snake.get(i+1) == foodY) {
            placeFood();
            checkFood();
          }
        }
      }
    }
  }
}

void end() {
  fontSizeZoom = 0;
  fill(255, 250, 240);
  background(0);
  for (int i=0; i<40; i++) {
    fill(255-((2-fontSizeZoom)*100));
    textSize(sin(fontSizeZoom)*25+150);
    fontSizeZoom += 0.05; 
    textAlign(CENTER, CENTER);
    text(int(round(snake.size()/2)), width/2, height/2);
  }
}

void UpdateSnake() {
  if (snake.size()>2) {
    for (int i=0; i<(snake.size()-2); i++) {
      k = ((snake.size()-2) - (i+1)); 
      snake.set(k+2, snake.get(k));
    }
  }
}

void checkCollisions() {
  if (collide < 2) {
    collide = 0;
  }
  for (int i=4; i<snake.size(); i+=2) {
    if (snake.get(i) == snakeX) {
      if (snake.get(i+1) == snakeY) {
        if (snakeX != foodX) {
          if (snakeY != foodY) {
            if (collide < 2) {
              collide = 1;
            }
          }
        }
      }
    }
  }
  if (collide == 1) {
    notEnd = false;
  } else {
    collide = 0;
  }
}

void border() {
  stroke(255);
  strokeWeight(10);
  line(0, 0, width, 0);
  line(width, 0, width, height);
  line(width, height, 0, height);
  line(0, height, 0, 0);
}

void draw() {

  if (notEnd) {

    noStroke();

    frameModCount ++;
    if (frameModCount == frameDelay) {
      move();
      frameModCount = 0;
      fill(0, 0, 0, 170);
      background(0);
      snake(); 
      food();
      UpdateSnake();
      statChange = stat;
    }

    if (snakeX < pix/2 || snakeX > width-pix) {
      notEnd = false;
    }
    if (snakeY < 0 || snakeY > height-pix) {
      notEnd = false;
    }

    if (abs(foodX - snakeX) < pix/3 && abs(foodY - snakeY) < pix/3) {
      getFood();
      checkFood();
    } else {
      toggle = 0;
    }

    checkCollisions();

    fill(255);
    textSize(30);
    text(int(round(snake.size()/2)), 70, 70);

    border();
  } else {
    end();
  }
}
