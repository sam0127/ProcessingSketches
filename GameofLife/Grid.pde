class Grid {
  int dimensionX;
  int dimensionY;
  
  boolean[][] state;
  
  Grid(int _dimensionX, int _dimensionY) {
    dimensionX = _dimensionX;
    dimensionY = _dimensionY;
    
    state = new boolean[dimensionY][dimensionX];
  }
  
  void setRandomMatrix(){
    for(int r = 0; r < dimensionY; r++){
      for(int c = 0; c < dimensionX; c++){
        float rand = random(0,1);
        if(rand > 0.5){
          state[r][c] = true;
        }
      }
    }
  }
  
  void drawGrid() {
    //background
    background(255);
    //draw vert lines
    /*
    for(int lon = 0; lon < dimensionX; lon++){
      line(lon*width/dimensionX, 0, lon*width/dimensionX, height);
    }
    
    //draw horizontal lines
    for(int lat = 0; lat < dimensionY; lat++){
      line(0, lat*height/dimensionY, width, lat*height/dimensionY);
    }*/
    //draw alive cells
    
    for(int i = 0; i < dimensionY; i++){
      for(int j = 0; j < dimensionX; j++){
        if(state[i][j]){
          fill(0);
          rect(j*width/dimensionX,i*height/dimensionY,width/dimensionX,height/dimensionY);
        }
      }
    }
  }
  
  void advance() {
    boolean[][] next = new boolean[dimensionY][dimensionX];
    
    for(int r = 0; r < dimensionY; r++){
      for(int c = 0; c < dimensionX; c++){
        int neighbors = numNeighbors(c,r);
        if(state[r][c]){
          if(neighbors < 2){
            next[r][c] = false; 
          }else if(neighbors > 3){
            next[r][c] = false; 
          }else{
            next[r][c] = true; 
          }
        }else{
          if(neighbors == 3){
            next[r][c] = true; 
          }else{
            next[r][c] = false; 
          }
        }
      }
    }
    state = next;
  }
  
  int numNeighbors(int x, int y){
    int num = 0;
    //four corners
  
    if(x == 0 && y == 0){ //top left
      if(state[x+1][y]) num++;
      if(state[x][y+1]) num++;
      if(state[x+1][y+1]) num++;
    }else if(x == 0 && y == dimensionY-1){ //bottom left
      if(state[x+1][y]) num++;
      if(state[x][y-1]) num++;
      if(state[x+1][y-1]) num++;
    }else if(x == dimensionX-1 && y == 0){ //top right
      if(state[x][y+1]) num++;
      if(state[x-1][y]) num++;
      if(state[x-1][y+1]) num++;
    }else if(x == dimensionX-1 && y == dimensionY-1){ //bottom right
      if(state[x-1][y]) num++;
      if(state[x][y-1]) num++;
      if(state[x-1][y-1]) num++; 
    }else{
      //sides
      if(x == 0){ //left
        if(state[x][y-1]) num++;
        if(state[x][y+1]) num++;
        if(state[x+1][y-1]) num++;
        if(state[x+1][y]) num++;
        if(state[x+1][y+1]) num++;
      }else if(x == dimensionX-1){ //right
        if(state[x][y-1]) num++;
        if(state[x][y+1]) num++;
        if(state[x-1][y-1]) num++;
        if(state[x-1][y]) num++;
        if(state[x-1][y+1]) num++;
      }else if(y == 0){ //top
        if(state[x-1][y]) num++;
        if(state[x+1][y]) num++;
        if(state[x-1][y+1]) num++;
        if(state[x][y+1]) num++;
        if(state[x+1][y+1]) num++;
      }else if(y == dimensionY-1){ //bottom
        if(state[x-1][y]) num++;
        if(state[x+1][y]) num++;
        if(state[x-1][y-1]) num++;
        if(state[x][y-1]) num++;
        if(state[x+1][y-1]) num++;
      }else{ //not on border
        if(state[x-1][y-1]) num++;
        if(state[x][y-1]) num++;
        if(state[x+1][y-1]) num++;
        if(state[x-1][y]) num++;
        if(state[x+1][y]) num++;
        if(state[x-1][y+1]) num++;
        if(state[x][y+1]) num++;
        if(state[x+1][y+1]) num++;
      }
    }
    return num;
  }
}
