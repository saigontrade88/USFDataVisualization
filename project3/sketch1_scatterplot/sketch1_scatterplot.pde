
Table myTable = null;
Frame myFirstFrame = null;
Frame mySecondFrame = null;

color[] dessert = {#9F9694, #791F33, #BA3D49, #F1E6D4, #E2E1DC};
color[] palette = dessert;

float THRESHOLD_INTERMEDIATE_SATM = 615;
float THRESHOLD_HIGH_SATM = 660;
float THRESHOLD_INTERMEDIATE_SATV = 615;
float THRESHOLD_HIGH_SATV = 650;
float THRESHOLD_INTERMEDIATE_ACT = 10;
float THRESHOLD_HIGH_ACT = 10;


int currentFrame = 0; // flag to catch which sketch is drawn.

//Handle the mouse click interaction
int Clicked = 0;

ScreenPosition lastClicked = null;

ScreenPosition lastSelected = null;

int Moved = 0;

void setup(){
  
  size(800,600);  
  
//  selectInput("Select a file to process:", "fileSelected");
 
// myTable = loadTable( "srsatact_cut.csv", "header" );
// myTable = loadTable( "srsatact.csv", "header" );
 
 myTable = loadTable( "ketchup_cut.csv", "header" );

  //myTable = loadTable( "ketchup.csv", "header" );

// myFirstFrame = new ScatterPlot( myTable, "SATM","SATV","SATM vs SATV", 200, 100, 400, 400);
 
// mySecondFrame = new ScatterPlot( myTable, "ACT","GPA","ACT vs GPA", 200, 100, 400, 400); 
 
 
//myFrame = new ScatterPlot( myTable, "SATM","SATV","SATM vs SATV", 200, 100, 400, 400);
// myFrame = new ScatterPlot( myTable, "ACT","GPA","ACT vs GPA", 200, 100, 400, 400);

myFirstFrame = new ScatterPlot( myTable, "price.heinz","price.hunts","price.heinz vs price.hunts", 200, 100, 400, 400);
mySecondFrame = new ScatterPlot( myTable, "price.delmonte","price.stb","price.heinz vs price.hunts", 200, 100, 400, 400);
 
 
}


void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    selectInput("Select a file to process:", "fileSelected");
  } else {
     println("User selected " + selection.getAbsolutePath());
     myTable = loadTable( selection.getAbsolutePath(), "header" );
   
    // TODO: create object
    // ScatterPlot( Table _data, String _useColumnX, String _useColumnY , String _chartName, int _xPos,int _yPos,int _sWidth, int _sHeight)
    myFirstFrame = new ScatterPlot( myTable,myTable.getColumnTitles()[0] ,myTable.getColumnTitles()[1],"SATM vs SATV", 200, 100, 400, 400);
    
    mySecondFrame = new ScatterPlot( myTable, myTable.getColumnTitles()[2],myTable.getColumnTitles()[3],"ACT vs GPA", 200, 100, 400, 400);
    
  }
}


void draw(){
  background( 255 );
  
  //noCursor();
    
  if( myTable == null ) 
    return;
    
 if( myFirstFrame == null ) 
    println("Your Frame is null");
 if(myFirstFrame != null ){  
    //Keyboard interaction to switch between the two sketches
    //Press l to select the SATM vs SATV
    //Press r to select the ACT vs GPA
    if (currentFrame == 0){
        textSize(15);
        fill(0);
        text(myFirstFrame.getColumnX(), 650, 75);
        //yellow
        fill(255, 255, 0);
        ellipse(650, 100, 16, 16);
        fill(0);
        text("<= " + THRESHOLD_INTERMEDIATE_SATM, 700, 100);
        //blue
        fill(0,0,255);
        ellipse(650, 150, 16, 16);
        fill(0);
        text("<= " + THRESHOLD_HIGH_SATM, 700, 150);
        //red
        fill(255,0,0);
        ellipse(650, 200, 16, 16);
        fill(0);
        text("> " + THRESHOLD_HIGH_SATM, 700, 200);
        myFirstFrame.draw();
      //  addTitleIfClicked(myFirstFrame);
      //  addTitleIfHover(myFirstFrame);
        
    }
    else{
        mySecondFrame.draw();
      //  addTitleIfClicked(mySecondFrame);
      //  addTitleIfHover(mySecondFrame);
    }
     
 }
  //keyPressed();
  //noLoop();
  
}

// Helper method that will draw description for each data point in the sketch if it was clicked/hovered
void addTitleIfClicked(Frame currentScatterPlot){
  
  if(Clicked == 1){
        lastClicked = new ScreenPosition((float) mouseX, (float) mouseY);
        int existed = currentScatterPlot.checkPointsForClick(lastClicked.getXPos(),lastClicked.getYPos());
        if(existed == 1){
           ScreenPosition temp = currentScatterPlot.returnPointsForClick(lastClicked);
           currentScatterPlot.showTitle(temp);
        }
        else{
          Clicked = 0;
          // clear the last selection
          lastClicked = null;
        }
  }
  
}

// If there is a marker selected 
void addTitleIfHover(Frame currentScatterPlot){
    lastSelected = new ScreenPosition((float) mouseX, (float) mouseY);
    int existed = currentScatterPlot.checkPointsForClick(lastSelected.getXPos(),lastSelected.getYPos());
    if(existed == 1){
           ScreenPosition temp = currentScatterPlot.returnPointsForClick(lastSelected);
           currentScatterPlot.showTitle(temp);
    }
    else{
          Moved = 0;
          // clear the last selection
          lastSelected = null;
    }
 }
 
void keyPressed() {
  //println(key);
  if(keyPressed){
      // Click "l" key
      if(key == 'l')
         currentFrame = 0;
      } // click "r" key
      if(key == 'r'){
        currentFrame = 1;
      } 
 }

/** The event handler for mouse clicks
* It will display a brief discription when the point is clicked
*/
void mouseClicked(){
  
     if(Clicked == 0){
       Clicked = 1;
       // clear the last selection
       lastClicked = null;
     }  
      //<>//
}

/** Event handler that gets called automatically when the 
 * mouse moves.
*/
void mouseMoved(){
  
      if(Moved == 0){
           Moved = 1;
           // clear the last selection
           lastSelected = null;
       }
  
}


void mouseReleased(){
  //myFirstFrame.mouseReleased();
}



abstract class Frame {
  
  int u0,v0,w,h;
  int clickBuffer = 2;
     
  void setPosition( int u0, int v0, int w, int h ){
    this.u0 = u0;
    this.v0 = v0;
    this.w = w;
    this.h = h;
  }
  
  abstract void draw();
  void mousePressed(){ }
  void mouseReleased(){ }
  void mouseClicked(){ }
  void mouseMoved(){}
  
 abstract int checkPointsForClick(float _mouseXPos, float _mouseYPos);
 
 abstract ScreenPosition returnPointsForClick(ScreenPosition p);
 
 abstract void showTitle(ScreenPosition p);
  
  
  boolean mouseInside(){
     return (u0-clickBuffer < mouseX) && (u0+w+clickBuffer)>mouseX && (v0-clickBuffer)< mouseY && (v0+h+clickBuffer)>mouseY; 
  }
  abstract String getColumnX();
  
}
