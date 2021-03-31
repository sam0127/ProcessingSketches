import processing.sound.*;
//COLORS//
color circleColor = color(255,0,0);
color lineColor = color(255,0,0);
color arcColor = color(255,0,0);
//
//MAIN CIRCLE DIMENSIONS//
int radius = 400;
int diameter = 2*radius;

int originX;
int originY;

float angle;
float angleNum;
float angleDenom;

//RADIUS LINES//

int fractionRadius = 1000;

float[] x3;
float[] y3;

float[] x4;
float[] y4;

float[] x5;
float[] y5;

float[] x6;
float[] y6;

float[] x7;
float[] y7;

float[] x8;
float[] y8;

float[] x9;
float[] y9;

float[] x10;
float[] y10;

boolean circleOver = false;
//
//BUTTON//
int buttonX;
int buttonY;
int buttonWidth = 128;
int buttonHeight = 128;
color buttonColor;
color buttonHighlight;
boolean buttonOver = false;
boolean textMode = false;
//
//BUTTON TEXT//
PFont f;
String buttonText = "";
String buttonState = "";

int textX;
int textY;
int textWidth = 128;
int textHeight = 128;

//INPUT TEXT//
String typingNum = "";
String typingDenom = "";
String numerator = "";
String denominator = "";
boolean inNumerator = true;
boolean inDenominator = false;



int itextX;
int itextY;
int itextWidth = 128;
int itextHeight = 256;

int numRectX;
int numRectY;
int numRectWidth = 128;
int numRectHeight = 16;

int denomRectX;
int denomRectY;
int denomRectWidth = 128;
int denomRectHeight = 16;

color inputBox;
color inputHighlight;

//SOUND//
SinOsc tonicOsc;
SinOsc ratioOsc;

float ratio;
int tonicFreq;

float vol;
//PLAY BUTTON//
int pbuttonX;
int pbuttonY;
int pbuttonWidth = 128;
int pbuttonHeight = 128;
color pbuttonColor;
color pbuttonHighlight;
boolean pbuttonOver = false;
boolean isPlay = false;

String pbuttonText = "";

int ptextX;
int ptextY;
int ptextWidth = 128;
int ptextHeight = 128;
//
//OTHER//
int ITER = 100;

void setup(){
  size(1200,960);
  originX = width/2;
  originY = height/2;
  
  angleNum = 0;
  angleDenom = 1;
  ratio = 0;
  
  //RADIUS LINE SETUP//
  x3 = new float[3];
  y3 = new float[3];
  
  for(int i = 0; i < 3; i++){
    x3[i] = cos(radians(360*(i+1)/3.0))*fractionRadius + width/2;
    y3[i] = sin(radians(360*(i+1)/3.0))*fractionRadius+height/2;
  }
  
  x4 = new float[4];
  y4 = new float[4];
  
  for(int i = 0; i < 4; i++){
    x4[i] = cos(radians(360*(i+1)/4.0))*fractionRadius + width/2;
    y4[i] = sin(radians(360*(i+1)/4.0))*fractionRadius+height/2;
  }
  
  x5 = new float[5];
  y5 = new float[5];
  
  for(int i = 0; i < 5; i++){
    x5[i] = cos(radians(360*(i+1)/5.0))*fractionRadius + width/2;
    y5[i] = sin(radians(360*(i+1)/5.0))*fractionRadius+height/2;
  }
  
  x6 = new float[6];
  y6 = new float[6];
  
  for(int i = 0; i < 6; i++){
    x6[i] = cos(radians(360*(i+1)/6.0))*fractionRadius + width/2;
    y6[i] = sin(radians(360*(i+1)/6.0))*fractionRadius+height/2;
  }
  //BUTTON SETUP//
  //text mode button
  buttonColor = color(128);
  buttonHighlight = color(196);
  
  buttonX = 10;
  buttonY = 10;
  
  //play button
  pbuttonColor = color(128);
  pbuttonHighlight = color(128);
  
  pbuttonX = 10;
  pbuttonY = 2*buttonY + buttonHeight;
  
  //TEXT SETUP//
  f = createFont("Arial",16);
  //text mode button
  textX = 10;
  textY = 10;
  buttonText = "Text input mode is ";
  buttonState = "FALSE";
  
  //play button
  ptextX = 10;
  ptextY = 2*textY+textHeight;
  pbuttonText = "PLAY";
  
  //TEXT INPUT SETUP
  itextX = (7*width)/8 - 64;
  itextY = height/4;
  
  numRectX = itextX;
  numRectY = itextY - 24;
  denomRectX = itextX;
  denomRectY = itextY;
  
  inputBox = color(128);
  inputHighlight = color(196);
  
  //SOUND//
  tonicFreq = 110;
  vol = 0.1;
  tonicOsc = new SinOsc(this);
  tonicOsc.freq(tonicFreq);
  tonicOsc.amp(vol);
  
  ratioOsc = new SinOsc(this);
  ratioOsc.amp(vol);
}

void draw(){
  update(mouseX,mouseY);
  background(0);
  fill(0);
  
  stroke(color(0,255,0));
  for(int i = 0; i < 3; i++){
    line(originX,originY,x3[i],y3[i]);
  }
  
  stroke(color(0,0,255));
    for(int i = 0; i < 4; i++){
    line(originX,originY,x4[i],y4[i]);
  }
  
  stroke(color(255,0,0));
    for(int i = 0; i < 5; i++){
    line(originX,originY,x5[i],y5[i]);
  }
  
  stroke(color(0,255,255));
    for(int i = 0; i < 6; i++){
    line(originX,originY,x6[i],y6[i]);
  }
  ellipse(originX,originY,diameter,diameter);
  stroke(circleColor);
  
  if(buttonOver){
    fill(buttonHighlight);
  }else{
    fill(buttonColor);
  }
  
  rect(buttonX,buttonY,buttonWidth,buttonHeight);
  
  if(pbuttonOver){
    fill(pbuttonHighlight);
  }else{
    fill(pbuttonColor);
  }
  
  rect(pbuttonX,pbuttonY,pbuttonWidth,pbuttonHeight);
  
  if(inNumerator){
    fill(inputHighlight);
    rect(numRectX,numRectY,numRectWidth,numRectHeight);
    fill(inputBox);
    rect(denomRectX,denomRectY,denomRectWidth,denomRectHeight);
  }else if(inDenominator){
    fill(inputHighlight);
    rect(denomRectX,denomRectY,denomRectWidth,denomRectHeight);
    fill(inputBox);
    rect(numRectX,numRectY,numRectWidth,numRectHeight);
  }
  
  textFont(f);
  
  fill(255);
  //text("Input " + typing, itextX, itextY-32); 
  text("Numerator: " + typingNum +"pi",itextX,itextY-24,itextWidth,itextHeight);
  text("Denominator: " + typingDenom,itextX,itextY,itextWidth,itextHeight);
  
  text(buttonText+buttonState,textX,textY,textWidth,textHeight);
  text(pbuttonText,ptextX,ptextY,ptextWidth,ptextHeight);

  stroke(lineColor);
  fill(0);
  
  if(textMode){
    ratio = angleNum/angleDenom;
    if(ratio < 0){
      ratio = -ratio;
    }
    angle = ratio*PI;
    
    arc(originX,originY,2*radius,2*radius,0,angle,CHORD);
    noFill();
    
    stroke(lineColor);
    drawChords(angle);
  }else{
    angle = atan2(mouseY - height/2, mouseX - width/2);
    if(angle < 0){
      angle += 2*PI;
    }
    ratio = angle / PI;
    
    arc(originX,originY,2*radius,2*radius,0,angle,CHORD);
    noFill();
    
    stroke(lineColor);
    drawChords(angle);
  }
  


  ratioOsc.freq(tonicFreq*ratio);
  
  if(isPlay){
    tonicOsc.play();
    ratioOsc.play();
  }else{
    tonicOsc.stop();
    ratioOsc.stop();
  }
}

void update(int x, int y) {
  if ( overCircle(originX, originY, diameter) ) {
    circleOver = true;
    buttonOver = false;
    pbuttonOver = false;
  } else if ( overRect(buttonX, buttonY, buttonWidth, buttonHeight) ) {
    buttonOver = true;
    circleOver = false;
    pbuttonOver = false;
  } else if(overRect(pbuttonX,pbuttonY,pbuttonWidth,pbuttonHeight)) {
    pbuttonOver = true;
    circleOver = false;
    buttonOver = false;
  } else {
    circleOver = buttonOver = pbuttonOver = false;
  }
}


void mousePressed() {
  if(buttonOver && textMode){
    textMode = false;
    buttonState = "FALSE";
  }else if(buttonOver && !textMode){
    textMode = true;
    buttonState = "TRUE";
  }else if(pbuttonOver && isPlay){
    isPlay = false;
    pbuttonText = "PLAY";
  }else if(pbuttonOver && !isPlay){
    isPlay = true;
    pbuttonText = "PAUSE";
  }
}

void keyPressed(){

  if(textMode){
    if(key == CODED){
      //Arrow keys change input field
      if(keyCode == UP || keyCode == DOWN){
        if(inNumerator){ inNumerator = false; inDenominator = true; }
        else if(inDenominator){ inNumerator = true; inDenominator = false; }
        else{ inNumerator = true; inDenominator = false; }
      }
    }else if(key == BACKSPACE){
      if(inNumerator){
        if(typingNum.length() != 0){
          typingNum = typingNum.substring(0,typingNum.length()-1);
        }
      }else if(inDenominator){
        if(typingDenom.length() != 0){
          typingDenom = typingDenom.substring(0,typingDenom.length()-1);
        }
      }
    }else if(key == '\n'){
      numerator = typingNum;
      denominator = typingDenom;
      
      //if input text is empty
      if(typingNum.length() == 0){
        angleNum = 0;
      }else{
        angleNum = Integer.valueOf(numerator);
      }
      if(typingDenom.length() == 0){
        angleDenom = 1;
      }else{
        angleDenom = Integer.valueOf(denominator);
      }
    }else{
      if(inNumerator){
        typingNum = typingNum + key;
      }else if(inDenominator){
        typingDenom = typingDenom + key;
      }
    }
  }
}
  

void drawChords(float angle){
  float resolution = 255/ITER;
  arcColor = color(255,0,0);
  for(int i = 2; i < ITER; i++){
    stroke(arcColor);
    arc(originX,originY,2*radius,2*radius,(i-1)*angle,i*angle,CHORD);
    arcColor = color(255-i*resolution,0,0);
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
