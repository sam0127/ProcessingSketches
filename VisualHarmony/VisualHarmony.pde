import processing.sound.*;
import interfascia.*;
//COLORS//
color circleColor = color(255,0,0);
color lineColor = color(255,0,0);
color arcColor = color(255,0,0);
//
//MAIN CIRCLE DIMENSIONS//
int radius = 200;
int diameter = 2*radius;

int originX;
int originY;

float angle;
float angleNum;
float angleDenom;

//RADIUS LINES//

int fractionRadius = 1000;
//math mode
RadiusLine[] halfs;
RadiusLine[] thirds;
RadiusLine[] quarters;
RadiusLine[] fifths;
RadiusLine[] sixths;
RadiusLine[] sevenths;
RadiusLine[] eighths;

color halfsColor = color(255,255,255);
color thirdsColor = color(0,255,0);
color quartersColor = color(0,0,255);
color fifthsColor = color(255,0,0);
color sixthsColor = color(0,255,255);
color seventhsColor = color(255,0,255);
color eighthsColor = color(0,50,128);

//music mode
RadiusLine[] tonics;
RadiusLine[] supertonics;
RadiusLine[] mediants;
RadiusLine[] subdominants;
RadiusLine[] dominants;
RadiusLine[] submediants;
RadiusLine[] subtonics;

color tonicsColor = color(255,255,255);
color supertonicsColor = color(0,255,255);
color mediantsColor = color(0,255,0);
color subdominantsColor = color(255,0,0);
color dominantsColor = color(0,0,255);
color submediantsColor = color(255,0,255);
color subtonicsColor = color(255,255,0);



//SOUND//
SinOsc tonicOsc;
SinOsc ratioOsc;

float ratio;
int tonicFreq;

float tonicAmp;
float ratioAmp;
//
//OTHER//
int ITER = 20;

//INTERFASCIA TEST//
GUIController c;
//IFTextField testText;

IFButton playButton;
boolean isPlay = false;

IFRadioController colorModeSwitch;
IFRadioButton mathModeRadioButton, musicModeRadioButton;

//GUI Frame
int radioRectX;
int radioRectY;
int radioRectWidth;
int radioRectHeight;

//CURSOR
float cursorTailX;
float cursorTailY;


//COLOR MODE
int colorMode;

void setup(){
  size(1200,960);
  originX = width/2;
  originY = height/2;
  
  angleNum = 0;
  angleDenom = 1;
  ratio = 0;
  
  //RADIUS LINE SETUP//
  //math mode
  halfs = new RadiusLine[2];
  halfs[0] = new RadiusLine(halfsColor,0);
  halfs[1] = new RadiusLine(halfsColor,PI);
  
  thirds = new RadiusLine[2];
  thirds[0] = new RadiusLine(thirdsColor,TWO_PI/3);
  thirds[1] = new RadiusLine(thirdsColor,2*TWO_PI/3);
  
  quarters = new RadiusLine[2];
  quarters[0] = new RadiusLine(quartersColor,HALF_PI);
  quarters[1]= new RadiusLine(quartersColor,3*HALF_PI);
  
  fifths = new RadiusLine[4];
  for(int i = 0; i < 4; i++){
    fifths[i] = new RadiusLine(fifthsColor,(i+1)*(TWO_PI/5));
  }
  
  sixths = new RadiusLine[2];
  sixths[0] = new RadiusLine(sixthsColor,PI/3);
  sixths[1] = new RadiusLine(sixthsColor,5*PI/3);
  
  sevenths = new RadiusLine[6];
  for(int i = 0; i < 6; i++){
    sevenths[i] = new RadiusLine(seventhsColor,(i+1)*(TWO_PI/7));
  }
  
  eighths = new RadiusLine[4];
  for(int i = 0; i < 4; i++){
    eighths[i] = new RadiusLine(eighthsColor,(i*HALF_PI)+QUARTER_PI);
  }
  
  //music mode
  tonics = new RadiusLine[4];
  for(int i = 0; i < 4; i++){
    tonics[i] = new RadiusLine(tonicsColor,TWO_PI/(pow(2,i)));
  }
  
  supertonics = new RadiusLine[2];
  supertonics[0] = new RadiusLine(supertonicsColor,9*PI/8);
  supertonics[1] = new RadiusLine(supertonicsColor,9*PI/16);
  
  mediants = new RadiusLine[2];
  mediants[0] = new RadiusLine(mediantsColor,5*PI/4);
  mediants[1] = new RadiusLine(mediantsColor,5*PI/8);
  
  subdominants = new RadiusLine[3];
  for(int i = 0; i < 3; i++){
    subdominants[i] = new RadiusLine(subdominantsColor, (4*PI)/(3*pow(2,i))); 
  }
  
  dominants = new RadiusLine[3];
  for(int i = 0; i < 3; i++){
    dominants[i] = new RadiusLine(dominantsColor, (3*PI)/(pow(2,i+1))); 
  }
  
  submediants = new RadiusLine[3];
  for(int i = 0; i < 3; i++){
    submediants[i] = new RadiusLine(submediantsColor, (5*PI)/(3*pow(2,i))); 
  }
  
  subtonics = new RadiusLine[2];
  subtonics[0] = new RadiusLine(subtonicsColor,15*PI/8);
  subtonics[1] = new RadiusLine(subtonicsColor,15*PI/16);
  
  
  //SOUND//
  tonicFreq = 220;
  tonicAmp = .1;
  tonicOsc = new SinOsc(this);
  tonicOsc.freq(tonicFreq);
  tonicOsc.amp(tonicAmp);
  
  ratioAmp = .1;
  ratioOsc = new SinOsc(this);
  ratioOsc.amp(ratioAmp);
  
  //GUI TEST/
  c = new GUIController(this);
  //testText = new IFTextField("Input",10,height/2+height/4);
  //estText.addActionListener(this);
  
  playButton = new IFButton("PLAY",10,10,100);
  playButton.addActionListener(this);
  
  colorModeSwitch = new IFRadioController("Color Mode");
  colorModeSwitch.addActionListener(this);
  mathModeRadioButton = new IFRadioButton("Math", 12, 40, colorModeSwitch);
  musicModeRadioButton = new IFRadioButton("Music", 12, 60, colorModeSwitch);
  
  //c.add(testText);
  c.add(playButton);
  c.add(colorModeSwitch);
  c.add(mathModeRadioButton);
  c.add(musicModeRadioButton);
  
  //radio rectangle
  radioRectX = 10;
  radioRectY = 40;
  radioRectWidth = 80;
  radioRectHeight = 40;
  
  
  //COLOR MODE
  colorMode = 0; //Math Mode
}

void draw(){

  background(0);
  fill(0);
  
  if(colorMode == 0){
    drawRadiusLines(halfs);
    drawRadiusLines(thirds);
    drawRadiusLines(quarters);
    drawRadiusLines(fifths);
    drawRadiusLines(sixths);
    drawRadiusLines(sevenths);
    drawRadiusLines(eighths);
  }else if(colorMode == 1){
    drawRadiusLines(tonics);
    drawRadiusLines(supertonics);
    drawRadiusLines(mediants);
    drawRadiusLines(subdominants);
    drawRadiusLines(dominants);
    drawRadiusLines(submediants);
    drawRadiusLines(subtonics);
  }
  
  //ellipse(originX,originY,diameter,diameter);
  stroke(circleColor);
 
  fill(255);

  stroke(lineColor);
  fill(0);
  
  angle = atan2(mouseY - height/2, mouseX - width/2);
  if(angle < 0){
    angle += 2*PI;
  }
  ratio = angle / PI;
  noFill();
  arc(originX,originY,2*radius,2*radius,0,angle,CHORD);
  noFill();
  
  stroke(lineColor);
  drawChords(angle);
  
  //Radio Rect
  fill(200);
  rect(radioRectX,radioRectY,radioRectWidth,radioRectHeight);
  //CURSOR
  stroke(255);                                                  //sqrt(pow(mouseX-originX,2)+pow(mouseY-originY,2))-20
  cursorTailX = cos(atan2(mouseY - height/2, mouseX - width/2))*(radius) + originX;
  cursorTailY = sin(atan2(mouseY - height/2, mouseX - width/2))*(radius) + originY;
  line(cursorTailX,cursorTailY,mouseX,mouseY);
  //line(mouseX, mouseY, cursorTailX,cursorTailY);

  ratioOsc.freq(tonicFreq*ratio);
  
  if(isPlay){
    tonicOsc.play();
    ratioOsc.play();
  }else{
    tonicOsc.stop();
    ratioOsc.stop();
  }
}

void actionPerformed(GUIEvent e){
  /*
  if(e.getSource() == testText){
    //println("message: " + e.getMessage());
    if(e.getMessage() == "Completed"){
    }
  }else */
  if(e.getSource() == playButton){
    //println("message: " + e.getMessage());
    if(e.getMessage() == "Clicked"){
      if(isPlay){
        isPlay = false;
        playButton.setLabel("PLAY");
      }else{
        isPlay = true;
        playButton.setLabel("PAUSE");
      }
    }
  }else if(e.getSource() == mathModeRadioButton){
    if(e.getMessage() == "Selected"){
      colorMode = 0;
    }
  }else if(e.getSource() == musicModeRadioButton){
    if(e.getMessage() == "Selected"){
      colorMode = 1;
    }
  }
}

void keyPressed(){
 if(key == ' '){
   if(isPlay){
      isPlay = false;
      playButton.setLabel("PLAY");
   }else{
      isPlay = true;
      playButton.setLabel("PAUSE");
   }
 }
}

void drawChords(float angle){
  float resolution = 255/ITER;
  arcColor = color(255,0,0);
  for(int i = 2; i < ITER; i++){
    //stroke(arcColor);
    arc(originX,originY,2*radius,2*radius,(i-1)*angle,i*angle,CHORD);
    //arcColor = color(255-i*resolution,0,0);
  }
}

void drawRadiusLines(RadiusLine[] lines){
  for(int i = 0; i < lines.length; i++){
    lines[i].drawLine();
  }
}

class RadiusLine {
  color c;
  float x;
  float y;
  
  RadiusLine(color _c, float angle){
    c = _c;
    x = cos(angle)*fractionRadius + width/2;
    y = sin(angle)*fractionRadius + height/2;
  }
  
  void setColor(color _c){
    c = _c;
  }
  void drawLine(){
    stroke(c);
    line(originX,originY,x,y);
  }
}
