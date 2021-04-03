import themidibus.*;
import processing.sound.*;
import interfascia.*;
import java.util.*;

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

IFRadioController inputModeSwitch;
IFRadioButton midiModeRadioButton, mouseModeRadioButton;

//GUI Frame
int colorRectX;
int colorRectY;
int colorRectWidth;
int colorRectHeight;

int inputRectX;
int inputRectY;
int inputRectWidth;
int inputRectHeight;

//CURSOR
float cursorTailX;
float cursorTailY;


//COLOR MODE
int colorMode;

//MIDI MODE
boolean midiMode;

//MIDI PROCESSING
MidiBus midiBus;

Map<Integer,SinOsc> concurrentNotes;

//FREQUENCY LOGIC
boolean justIntonation;
float fundamentalFreq;
int fundamentalPitch;
int interval;
//float latestIntervalPlayed;

ArrayList<Float> intervalRatios;
float prime = 1.0;
float minSecond = 16.0/15.0;
float majSecond = 9.0/8.0;
float minThird = 6.0/5.0;
float majThird = 5.0/4.0;
float fourth = 4.0/3.0;
float tritone = 7.0/5.0;
float fifth = 3.0/2.0;
float minSixth = 8.0/5.0;
float majSixth = 5.0/3.0;
float minSeventh = 7.0/4.0;
float majSeventh = 15.0/8.0;

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
  
  inputModeSwitch = new IFRadioController("Input Mode");
  inputModeSwitch.addActionListener(this);
  midiModeRadioButton = new IFRadioButton("MIDI", 12,90,inputModeSwitch);
  mouseModeRadioButton = new IFRadioButton("Mouse", 12,110,inputModeSwitch);
  
  
  //c.add(testText);
  c.add(playButton);
  c.add(colorModeSwitch);
  c.add(mathModeRadioButton);
  c.add(musicModeRadioButton);
  c.add(inputModeSwitch);
  c.add(midiModeRadioButton);
  c.add(mouseModeRadioButton);
  
  //color rectangle
  colorRectX = 10;
  colorRectY = 40;
  colorRectWidth = 80;
  colorRectHeight = 40;
  
  inputRectX = 10;
  inputRectY = 90;
  inputRectWidth = 80;
  inputRectHeight = 40;
  
  //COLOR MODE
  colorMode = 0; //Math Mode
  
  //PLAY MODES
  
  midiMode = false;
  
  //MIDI
  midiBus = new MidiBus(this,0,1);
  
  concurrentNotes = new HashMap<Integer,SinOsc>();
  
  //Frequency
  
  justIntonation = true;
  //latestIntervalPlayed = 1.0;
  

  intervalRatios = new ArrayList<Float>();
  intervalRatios.add(prime);
  intervalRatios.add(minSecond);
  intervalRatios.add(majSecond);
  intervalRatios.add(minThird);
  intervalRatios.add(majThird);
  intervalRatios.add(fourth);
  intervalRatios.add(tritone);
  intervalRatios.add(fifth);
  intervalRatios.add(minSixth);
  intervalRatios.add(majSixth);
  intervalRatios.add(minSeventh);
  intervalRatios.add(majSeventh);
  
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
  
  if(midiMode){
    //ratio = latestIntervalPlayed;
    angle = ratio*PI;
    
    noFill();
    arc(originX,originY,2*radius,2*radius,0,angle,CHORD);

    drawChords(angle);
  }else{
    angle = atan2(mouseY - height/2, mouseX - width/2);
    if(angle < 0){
      angle += 2*PI;
    }
    ratio = angle / PI;
    noFill();
    arc(originX,originY,2*radius,2*radius,0,angle,CHORD);
    //noFill();
    
    //stroke(lineColor);
    drawChords(angle);
    
    ratioOsc.freq(tonicFreq*ratio);
    
    if(isPlay){
      tonicOsc.play();
      ratioOsc.play();
    }else{
      tonicOsc.stop();
      ratioOsc.stop();
    }
  }
  
  //Radio Rect
  fill(200);
  rect(colorRectX,colorRectY,colorRectWidth,colorRectHeight);
  //input rect
  rect(inputRectX,inputRectY,inputRectWidth,inputRectHeight);
  //CURSOR
  stroke(255);                                                  //sqrt(pow(mouseX-originX,2)+pow(mouseY-originY,2))-20
  cursorTailX = cos(atan2(mouseY - height/2, mouseX - width/2))*(radius) + originX;
  cursorTailY = sin(atan2(mouseY - height/2, mouseX - width/2))*(radius) + originY;
  line(cursorTailX,cursorTailY,mouseX,mouseY);
  //line(mouseX, mouseY, cursorTailX,cursorTailY);

  
}

void actionPerformed(GUIEvent e){ 
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
  }else if(e.getSource() == midiModeRadioButton){
    if(e.getMessage() == "Selected"){
      midiMode = true;
    }
  }else if(e.getSource() == mouseModeRadioButton){
    if(e.getMessage() == "Selected"){
      midiMode = false;
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

void noteOn(int channel, int pitch, int velocity, long timestamp, String bus_name){
  println(channel, pitch, velocity, timestamp);
  SinOsc s = new SinOsc(this);
  //println(fundamental);
  if(justIntonation && concurrentNotes.size() == 0){
    fundamentalFreq = midiToFreq(pitch,false);
    fundamentalPitch = pitch;
  }
  s.play(midiToFreq(pitch,justIntonation),velToAmp(velocity));
  concurrentNotes.put(new Integer(pitch),s);
  
  
  //println(fundamental);
}

void noteOff(int channel, int pitch, int velocity, long timestamp, String bus_name){
  println(channel, pitch, velocity, timestamp);
  concurrentNotes.remove(new Integer(pitch)).stop();
}

int mod;
int oct;
float midiToFreq(int note, boolean mode){
  if(mode){
    interval = note - fundamentalPitch;
    
    if(interval < 0){
      oct = (interval / 12) - 1;
      interval = abs(interval % 12);
    }else{
      oct = interval / 12;
      interval %= 12;
    }
    
    //latestIntervalPlayed = intervalRatios.get(interval)*pow(2,oct);
    return fundamentalFreq * intervalRatios.get(interval)*pow(2,oct);
  }else{
    return (pow(2, ((note-69)/12.0))) * 440;
  }
  
}

float velToAmp(int vel){
  return vel/127.0;
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
