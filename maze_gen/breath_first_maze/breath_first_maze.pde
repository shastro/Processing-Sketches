ArrayList<Cell> grid;
ArrayList<Cell> stack;

int w = 200;
int cols;
int rows;
Boolean click = false;
Cell current;
//Cell grid = new LinkedList();

//stack = new ArrayList<Cell>();
//Cell[][] grid = new Cell[cols][rows];
void setup(){
  size(1000, 1000);
  //background(51);
  colorMode(HSB);
  cols = floor(width/w);
  rows = floor(height/w);
  grid = new ArrayList<Cell>();
  stack = new ArrayList<Cell>();

  /*Grid init*/
  for (int j = 0; j < rows; j++){
    for(int i= 0; i < cols; i++){
      grid.add(new Cell(i,j));
    }
  }
  current = grid.get(0);
}
Boolean finished = false;
void draw(){
  background(51);
 // println(frameRate);
   //frameRate(1);
   int counter = 0;
   do{ 
      /*
      for (int i = 0; i < grid.size(); i++){
        if(grid.get(i).visited){
          grid.get(i).show();
        }
      }
      */
      //for (int i = 0; i < grid.size(); i++){
        // grid.get(i).show();
        
      //}
      current.visited = true;

      current.highlight();
      
      Cell next = current.checkNeighbors();
      if (next != null){
        next.visited = true;
        stack.add(current);
        removeWalls(current, next);
        //current.col = color(frameCount%255,0,255,101);
        current = next;
        
      } else if (stack.size() > 0){
        current = stack.remove(stack.size() - 1);
      }

       if (((current.i == 0 & current.j == 0) & (counter > 0))){
         //current.highlight();
         finished = true;
       }
      counter++;
      println(current.i,current.j);
      println(counter,finished);
   }while (!finished);
    
    
    for (int i = 0; i < grid.size(); i++){
       grid.get(i).show();
      
    }
    //println(grid.get(0).visited);
    
    //current.show();
    /*
    for (int i = 0; i < stack.size(); i++){
      stack.get(i).show();
    }
    */

    

  if (click){
    mousePressed();
    click = false;
  }

  noLoop();
}

class Cell
{
  int i;
  int j;
  Boolean[] walls;
  Boolean visited;
  color col;
  Cell(int i, int j){
    this.i = i;
    this.j = j;
    walls = new Boolean[]{true,true,true,true};
    this.visited = false;
    this.col = color(frameCount%255,255,255,100);
  }
  Cell checkNeighbors(){
    ArrayList<Cell> neighbors = new ArrayList<Cell>();
    
   
    if(index(i, j-1) != -1){
      Cell top = grid.get(index(i, j-1));
      if(!top.visited){
        neighbors.add(top);
      }
    }
    if(index(i + 1, j) != -1){
      Cell right = grid.get(index(i + 1, j));
      if(!right.visited){
        neighbors.add(right);
      }
    }
    if(index(i, j+1) != -1){
      Cell bottom = grid.get(index(i, j+1));
      if(!bottom.visited){
        neighbors.add(bottom);
      }
    }
    if(index(i - 1, j) != -1){
      Cell left = grid.get(index(i - 1, j));
      if(!left.visited){
        neighbors.add(left);
      }
    }
    
    
    if (neighbors.size() > 0){
      int r = floor(random(0, neighbors.size()));
      return neighbors.get(r);
    } else {
      return null;
    }
    
  }
  void highlight(){
    int x = this.i*w;
    int y = this.j*w;
    noStroke();
    fill(0,0,255,255);
    rect(x,y,w,w);
  }
  void show(){
    int x = this.i * w;
    int y = this.j * w;
    stroke(255);
    
     
    if(walls[0]){
    line(x,y,x+w,y);
    }
    if(walls[1]){
    line(x+w,y,x+w,y+w);
    }
    if(walls[2]){
    line(x+w,y+w,x,y+w);
    }
    if(walls[3]){
    line(x,y+w,x,y);
    }
    if(this.visited){
      fill(this.col);
      noStroke();
      rect(x,y,w,w);
    }
    
  }
}

int index(int i, int j){
   if(i < 0 || j < 0 || i > (cols -1) || j > (rows-1)){
     return -1;
   }
   return i + j * cols;
}

void removeWalls(Cell cur, Cell nxt){
  int dx = cur.i - nxt.i;
  int dy = cur.j- nxt.j;
  
  if (dx == 1){ //Next is to the left
    cur.walls[3] = false;
    nxt.walls[1] = false;
  }else if (dx == -1){ //Next is to the right
    cur.walls[1] = false;
    nxt.walls[3] = false;
  }
  if (dy == 1){ //Next is to the bottom
    cur.walls[0] = false;
    nxt.walls[2] = false;
  }else if (dy == -1){ //Next is to the top
    cur.walls[2] = false;
    nxt.walls[0] = false;
  }
}

void mousePressed(){
  saveFrame("snip###.png");
}
