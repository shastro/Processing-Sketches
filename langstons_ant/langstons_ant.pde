final int ANTUP = 0;
final int ANTRIGHT = 1;
final int ANTDOWN = 2;
final int ANTLEFT = 3;
boolean pressed = false;
int[][] grid;
int x;
int y;
int dir;

int BGCOL = 60;

PImage ant;


void setup(){
 size(1080, 1350);
 frameRate(30);
 colorMode(HSB);
 grid = new int[width][height];
 ant = createImage(width, height, HSB);
 ant.loadPixels();
 for ( int i = 0; i < ant.pixels.length; i++){
   ant.pixels[i] = color(BGCOL);
 }
 ant.updatePixels();
 x = width/2;
 y = height/2;
 
 dir = ANTUP;
 
 
}

void turnRight(){
  dir++;
  if (dir > ANTLEFT){
    dir = ANTUP;
  }
}
void turnLeft(){
  dir--;
  if (dir < ANTUP){
    dir = ANTLEFT;
  }
}
void moveForward(){
  switch (dir){
    
    case ANTUP:
      y = (y - 1);
      break;
    case ANTLEFT:
      x = (x - 1);
      break;
    case ANTDOWN:
      y = (y + 1);
      break;
    case ANTRIGHT:
      x = (x + 1);
      break;
      
  }
  if (y > height - 1){
     y = 0;
  } else if ( y < 0){
    y = height -1;
  }
     
  if (x > width-1) {
    x = 0;
  } else if (x < 0) {
    x = width-1;
  }
}
void draw(){
 //background(255);
 ant.loadPixels();
 for (int n = 0; n < 30000; n++){
   int state = grid[x][y]; 
   
   if (state == 0){
     turnRight();
     grid[x][y] = 1;
   }else if (state == 1){
     turnLeft();
     grid[x][y] = 0;
   }
   //color(5*frameCount%255,255,255,255);
   color col = color(0);
   if (grid[x][y] == 1){
     col = color(2*frameCount%255,255,255,255);
   } else if (grid[x][y] == 0 ){
     col = color(2*frameCount%255,255,255,255);
   }
   int pix = x + y * ant.width;
   ant.pixels[pix] = col;
   moveForward();
  }
  ant.updatePixels();
  image(ant,0,0);
  if (pressed){
    saveFrame("screenshot##.png");
    pressed = false;
  }
  //saveFrame("output2/frame_####.png"); Produces Animation when uncommented
}
void mousePressed(){
  pressed = true;
}
