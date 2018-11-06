ArrayList<Cell> grid;
ArrayList<Cell> stack;
ArrayList<Cell> openset;
ArrayList<Cell> closedset;
ArrayList<Cell> path;

int w = 3; //Defines size of cell in pixels
int cols;
int rows;
Boolean click = false;
Boolean USEASTAR = false; //USE THIS TO DISABLE ASTAR
Cell current;
Cell start;
Cell end;

enum mode{
  SLOWGEN
};

//Cell grid = new LinkedList();

//stack = new ArrayList<Cell>();
//Cell[][] grid = new Cell[cols][rows];
void setup(){
  //size(1080, 2220); //Phone
  size(1000,1000);
  colorMode(HSB);
  background(51);
  cols = floor(width/w);
  rows = floor(height/w);
  grid = new ArrayList<Cell>();
  stack = new ArrayList<Cell>();
  openset = new ArrayList<Cell>();
  closedset = new ArrayList<Cell>();
  path = new ArrayList<Cell>();
  /*Grid init*/
  for (int j = 0; j < rows; j++){
    for(int i= 0; i < cols; i++){
      grid.add(new Cell(i,j));
    }
  }
  int r = int(random(grid.size()-1));
  //int r = 0;
  current = grid.get(r);
  
  //A* cell inits
  start = grid.get(0);
  end = grid.get(index(cols - 1, rows - 1));
  
  openset.add(start);
  /* a_neighbor init*/
  for (int i = 0; i < grid.size(); i++){
    grid.get(i).a_addNeighbors();
  }
  
}
Boolean finished = false;
int counter = 0;
String mode = "gen";
Boolean isgenerated = false;

void draw(){
  //background(51);
  println(frameRate);
  

   //frameRate(1);
   do{ 
       //Use When visualizing slowly instead of generating
      //for (int i = 0; i < grid.size(); i++){
        //if(grid.get(i).visited){
          //grid.get(i).show();
        //}
      //}
      
      //for(int s = 0; s < 10; s++){ This is for creating more speed when visualizing more slowly
      
      //for (int i = 0; i < grid.size(); i++){ Old Functionality
         //grid.get(i).show();
        
      //}
      current.visited = true;

      if (!finished){
        current.highlight();
      }
      Cell next = current.checkNeighbors();
      if (next != null){
        next.visited = true;
        stack.add(current);
        removeWalls(current, next);
        //current.col = color(255,255,255,101);
        current = next;
        
      } else if (stack.size() > 0){
        current = stack.remove(stack.size() - 1);
      }

       if (((current.i == 0 & current.j == 0) & (counter > 0))){
         finished = true;
       }
      counter++;
      println(current.i,current.j);
      //println(counter,finished);
   }while (!finished);
   //} *end of for(int s = 0; s < 10; s++)
   
    if(!isgenerated){
      for (int i = 0; i < grid.size(); i++){
        if(grid.get(i).visited){
          grid.get(i).show();
        }
      }      
      //for (int i = 0; i < grid.size(); i++){
         //grid.get(i).show();
         isgenerated = true;
      //}
    }
    //*A star ---------------------------------------------
    if(USEASTAR){
      if (openset.size() > 0){
        int lowestIndex = 0;
        for (int i = 0; i < openset.size(); i++){
          if(openset.get(i).f < openset.get(lowestIndex).f){
            lowestIndex = i;
          }
        }
        
       Cell a_current = openset.get(lowestIndex);
       
       if (a_current == end){

         println("Done!");
       }
       
       openset.remove(a_current);
       closedset.add(a_current);
       
       for (int i = 0; i < a_current.a_neighbors.size(); i++){
         Cell neighbor = a_current.a_neighbors.get(i);
         if(!closedset.contains(neighbor)){
           int tmpg = a_current.g + 1;
           if (openset.contains(neighbor)){
             if(tmpg < neighbor.g){
               neighbor.g = tmpg;
             }
           } else {
             neighbor.g = tmpg;
             openset.add(neighbor);
           }
           //Core Algorithm
           neighbor.h = heuristic(neighbor,end);
           neighbor.f = neighbor.g + neighbor.h;
           neighbor.previous = current;
             
         }
       }
       
      } else {
        //nosolution
      }
  
      for (int i = 0; i < closedset.size(); i++){
        grid.get(i).a_col = color(255,0,0,255);
        grid.get(i).a_show();
      }
      for (int i = 0; i < openset.size(); i++){
        grid.get(i).a_col = color(0,255,0,255);
        grid.get(i).a_show();      
      }
       Cell temp = current;
       path.add(temp);
       while(temp.previous != null){
         path.add(temp.previous);
         temp = temp.previous;
       }
      for (int i = 0; i < path.size(); i++){
        grid.get(i).a_col = color(200,0,0,255);
        grid.get(i).a_show();      
      }
    }

    
  
  if (click){
    mousePressed();
    click = false;
  }
  println(isgenerated);
  noLoop();
}
float heuristic(Cell a, Cell b){
  float d = dist(a.i, a.j, b.i, b.j);
  return d;
}
class Cell
{
  int i;
  int j;
  Boolean[] walls;
  Boolean visited;
  color col;
  //A star vars
  float f = 0;
  int g = 0;
  float h = 0;
  color a_col;
  ArrayList<Cell> a_neighbors = new ArrayList<Cell>();
  Cell previous = null;
  
  Cell(int i, int j){
    this.i = i;
    this.j = j;
    walls = new Boolean[]{true,true,true,true};
    this.visited = false;
    this.col = color(0,255,255,0);
  }
  Cell(int i, int j, color a_col){ //Constructor Overloading
    this.i = i;
    this.j = j;
    this.a_col = a_col;
    walls = new Boolean[]{true,true,true,true};
    this.visited = false;
    this.col = color(0,255,255,0);
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
  void a_addNeighbors(){
    
    if(index(i, j-1) != -1){
      Cell top = grid.get(index(i, j-1));
      a_neighbors.add(top);
      
    }
    if(index(i + 1, j) != -1){
      Cell right = grid.get(index(i + 1, j));
      a_neighbors.add(right);
      
    }
    if(index(i, j+1) != -1){
      Cell bottom = grid.get(index(i, j+1));
      a_neighbors.add(bottom);
      
    }
    if(index(i - 1, j) != -1){
      Cell left = grid.get(index(i - 1, j));
      a_neighbors.add(left);
      
    }
  }
  void highlight(){
    int x = this.i*w;
    int y = this.j*w;
    noStroke();
    fill(255,255,130,255);
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
  //A* show
  void a_show(){
    int x = this.i * w;
    int y = this.j * w;
    fill(this.a_col);
    noStroke();
    rect(x,y, w - 2, w - 2);
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
  int r = int(random(1000));
  saveFrame("snip" + r +".png");
}
