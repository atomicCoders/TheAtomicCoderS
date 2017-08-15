World world;
Audio a;
PFont mono;
int r = 200;
int yearsOfRadioactivity = 0;
float BGcount = 0, volume = -20.0, setVolume = volume;
boolean gameStart = false, blink = false, pause = false, 
  playSound = true, idleMode = true, showIdleModeText = true;
color water = color(0, 150, 255), white = color(255), black = color(0), grey = color(51),
  drilling = color(255, 0, 0), radWaste = color(0, 255, 0), 
  grass = color(10, 255, 50), land = color(180, 100, 10);
void settings() {
  int theHeight = floor((displayHeight - 50) / 100) * 100;
  size(1400, theHeight, P3D);
}
void setup() {
  background(0); 
  world = new World();
  a = new Audio();
  backGround = new Minim(this);
  BG = backGround.loadFile("DescenteInfinie_03.aiff", 2048);
  mono = loadFont("SourceCodePro-Black-24.vlw");
  textAlign(CENTER);
  textSize(24);
  textFont(mono);
}
void draw() {
  //lights(); 
  ortho(); 
  background(0);  
  //blinking red for drama!
  if (blink)background(abs(sin(BGcount)) * 150, 0, 0);
  //draws the frame around the game
  frame();  
  if (pause) {
    pushMatrix();
    translate(width / 2, height * 0.4, 200);
    rectMode(CENTER);
    fill(black);
    rect(0, 20, 450, 100);    
    fill(white);
    text("DO YOU WANT TO LEAVE THE GAME?\nY/N\nDIED CREATURES: " + world.killedLivingCreatures, 0, 0);
    popMatrix();
  }
  if (idleMode) {
    pushMatrix();
    translate(width / 2, height * 0.4, 200);
    rectMode(CENTER);
    fill(black);
    stroke(white);     
    rect(0, 20, 450, 100);    
    fill(white);
    text("CLICK THE MOUSE TO START", 0, 0);
    popMatrix();
  }
  if (gameStart && !pause) {
    world.update();
    noFill();
    stroke(drilling);
    rectMode(CORNER);
    rect(50, 50, 200, height - 100);
    image(radioactivity(), 50, 50);
  }  
  world.worldRotation();
  world.show();
  if (!idleMode) {
    world.drillinganimation();
    world.atomAnimation();
  }
  BGcount += 0.05;
  surface.setTitle(str(frameRate));
  if (playSound) {
    BGSound();
    playSound = false;
  }
}
void BGSound() {  
  BG.setGain(volume);
  BG.loop();
}
void frame() {
  int cell = 20;
  int cols = width / cell;
  int rows = height / cell;
  stroke(255);
  strokeWeight(3);
  pushMatrix();
  rotateX(0);
  rotateZ(0);
  for (int i = 0; i < cols; i += 1) {
    line(i * cell, 0, (i + 1) * cell, cell);
    line(i * cell, height - cell, (i + 1) * cell, height);
  }
  for (int i = 0; i < rows; i += 1) {
    line(0, i * cell, cell, (i + 1) * cell);
    line(width - cell, i * cell, width, (i + 1) * cell);
  }
  popMatrix();
}
int radioactivityLevel() {
  //returns the years of radioactivity left as an int
  //high the radition level is based on time 2017 – 12017
  //int y = year();
  //yearsOfRadioactivity = 12017 - y;
  int y = second();
  yearsOfRadioactivity = 59 - y;
  return yearsOfRadioactivity;
}
PImage radioactivity() {
  imageMode(CORNER);
  PImage img = createImage(200, height - 100, RGB);
  //int amountOfRadioactivityLeft = floor(map(radioactivityLevel(),10000, 0, 0, img.pixels.length));
  //if minute
  int amountOfRadioactivityLeft = floor(map(radioactivityLevel(), 59, 0, 0, img.pixels.length));
  for (int i = 0; i < amountOfRadioactivityLeft; i++)img.pixels[i] = black; 
  for (int i = amountOfRadioactivityLeft; i < img.pixels.length; i++) {
    float amt = map(i, amountOfRadioactivityLeft, amountOfRadioactivityLeft + 2000, 0, 1);
    color c = lerpColor(black, radWaste, amt);
    img.pixels[i] = c;
  }
  return img;
}
void keyPressed() {
  if (key == ' ') pause = true;
  if (world.paddle.w <= 20)if (key == 'r')world.paddle.w = 100;
  if (pause) {
    if (key == 'y') {
      world.init(); 
      idleMode = true;      
      blink = false;
      setVolume = volume;
      BG.shiftGain(BG.getGain(), volume, 1000);
      pause = !pause;
    }
    if (key == 'n')pause = !pause;
  }
}
void mousePressed() {
  idleMode = false;
}