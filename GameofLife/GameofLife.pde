int x;
int y;

Grid game;

void setup(){
  size(1000,1000);
  x = 100;
  y = 100;
  
  game = new Grid(x,y);
  game.setRandomMatrix();
}

void draw(){
  game.drawGrid();
  game.advance();
  //wait some time
  delay(100);
}
