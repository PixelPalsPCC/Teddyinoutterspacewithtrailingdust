// Camera variables
float cameraZ = 0;
float targetZ = 0;
float rotationX = 0;
float rotationY = 0;
float easing = 0.05;

// Teddy variables
PImage teddy;
float teddyX, teddyY, teddyZ;

// Star arrays
int[] starX = new int[200];
int[] starY = new int[200];
color[] starColor = new color[200];
int starSize = 2;
int twinkleTimer = 0;

// Particle system
ArrayList<Particle> particles = new ArrayList<Particle>();

class Particle {
  float x, y;
  float vx, vy;
  float alpha;
  float size;
  
  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    this.vx = random(-2, 2);
    this.vy = random(-2, 2);
    this.alpha = 255;
    this.size = random(2, 6);
  }
  
  void update() {
    x += vx;
    y += vy;
    alpha -= 5;  // Fade rate
  }
  
  void display() {
    noStroke();
    fill(255, 255, 255, alpha);
    ellipse(x, y, size, size);
  }
  
  boolean isDead() {
    return alpha < 0;
  }
}

void setup() {
  size(800, 800, P3D);

  teddy = loadImage("teddyinspaceteenynobackground.png");
  if (teddy == null) {
    println("ERROR: Failed to load image!");
    println("Make sure the image file is in the data folder and the name matches exactly");
    exit();
  } else {
    println("Image loaded successfully!");
    println("Image size: " + teddy.width + " x " + teddy.height);
  }
  
  // Initialize positions
  teddyX = width/2;
  teddyY = height/2;
  teddyZ = 0;
  
  // Initialize background stars
  for (int i = 0; i < starX.length; i++) {
    starX[i] = (int)random(-width, width*2);
    starY[i] = (int)random(-height, height*2);
    starColor[i] = color(255, random(200, 255));
  }
}

void draw() {
  background(0, 0, 50);
  
  // Draw background stars
  twinkleTimer++;
  if (twinkleTimer > 10) {
    for (int i = 0; i < 3; i++) {
      int starIndex = (int)random(starX.length);
      starColor[starIndex] = color(255, random(200, 255));
    }
    twinkleTimer = 0;
  }
  
  // Draw background stars
  for (int i = 0; i < starX.length; i++) {
    fill(starColor[i]);
    drawStar(starX[i], starY[i], starSize, 255);
  }

  // Move Teddy
  float targetX = mouseX - width/2;
  float targetY = mouseY - height/2;
  teddyX += (targetX - teddyX) * easing;
  teddyY += (targetY - teddyY) * easing;
  
  // Update and draw particles
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    if (p.isDead()) {
      particles.remove(i);
    }
  }
  
  // Add new particles
  for (int i = 0; i < 3; i++) {  // Adjust number for more/less particles
    particles.add(new Particle(teddyX + random(-20, 20) + width/2, 
                             teddyY + random(-20, 20) + height/2));
  }

  // Draw Teddy with 3D rotation
  pushMatrix();
  translate(width/2, height/2, cameraZ);
  rotateX(rotationX);
  rotateY(rotationY);
  
  if (teddy != null) {
    pushMatrix();
    translate(teddyX, teddyY, teddyZ);
    rotateX(-rotationX);
    rotateY(-rotationY);
    imageMode(CENTER);
    image(teddy, 0, 0);
    popMatrix();
  }
  popMatrix();
}

void drawStar(float x, float y, float size, float brightness) {
  pushMatrix();
  translate(x, y);
  
  stroke(255, 255, 255, brightness);
  strokeWeight(1);
  float innerSize = size * 0.4;
  
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i <= 10; i++) {
    float angle = i * TWO_PI / 5;
    float r = (i % 2 == 0) ? size : innerSize;
    float starX = cos(angle) * r;
    float starY = sin(angle) * r;
    vertex(starX, starY);
  }
  endShape(CLOSE);
  
  popMatrix();
}

void mouseDragged() {
  rotationY += (mouseX - pmouseX) * 0.01;
  rotationX += (mouseY - pmouseY) * 0.01;
}

void mouseWheel(MouseEvent event) {
  targetZ += event.getCount() * 50;
}
