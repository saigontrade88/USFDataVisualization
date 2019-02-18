
Table myTable = null;
Frame myFirstFrame = null;
Frame mySecondFrame = null;
ArrayList<ScatterPlot> myScatterplotList = null; 
ArrayList<Barchart> myBarchartList = null;
ArrayList<Linechart> myLinechartList = null;
ScatterPlot mySelectedScatterplot = null;
Frame myFirstLineChart = null;
Frame myFirstBarChart = null;

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
  
  size(1000,700);  
  
//  selectInput("Select a file to process:", "fileSelected");
 
  
  //*Test: first data set
  //myTable = loadTable( "srsatact_cut.csv", "header" );
    myTable = loadTable( "srsatact.csv", "header" );
  //*Test: second data set
  //  myTable = loadTable( "ketchup_cut_100.csv", "header" );
   myTable = loadTable( "ketchup.csv", "header" );
  //*Test: third data set
  //myTable = loadTable( "iris_cut.csv.csv", "header" );
  //myTable = loadTable( "iris_cut.csv", "header" );
   myTable = loadTable( "iris.csv", "header" );


// Create the scatterplot containers
  myScatterplotList = new ArrayList<ScatterPlot>();
  for(int i = 0; i < myTable.getColumnCount();i++){
       for(int j = 0; j < myTable.getColumnCount(); j++){
           if(i != j){
           //print("i= " + i + "origin is= " + i*width/4);
           //ScatterPlot( Table _data, String _useColumnX, String _useColumnY, String _chartName, int _xPos, int _yPos, int _sWidth, int _sHeight) 
           ScatterPlot temp = new ScatterPlot( myTable, myTable.getColumnTitles()[i], myTable.getColumnTitles()[j], myTable.getColumnTitles()[i] + " vs " + myTable.getColumnTitles()[j], 200, 100, 400, 400);
           myScatterplotList.add(temp);
           }
       }
  }

  //Line chart
  myLinechartList = new ArrayList<Linechart>();
  
  for(int i = 0; i < myTable.getColumnCount();i++){
             
         Linechart temp = new Linechart( myTable, myTable.getColumnTitles()[i], myTable.getColumnTitles()[i], 100, 50, 500, 600);
         myLinechartList.add(temp);        
  }
  

  //Bar chart

  myBarchartList = new ArrayList<Barchart>();
  
  for(int i = 0; i < myTable.getColumnCount();i++){
             
         Barchart temp = new Barchart( myTable, myTable.getColumnTitles()[i], myTable.getColumnTitles()[i], 100, 50, 500, 600);
         myBarchartList.add(temp);        
  }

}


void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    selectInput("Select a file to process:", "fileSelected");
  } else {
     println("User selected " + selection.getAbsolutePath());
     myTable = loadTable( selection.getAbsolutePath(), "header" );
       
  }
}


void draw(){
  
  background( 255 );
  
  //noCursor();
    
  if(myTable == null) 
    return;
        
  //Draw line chart
 
  
  for(int i = 0; i < myLinechartList.size();i++){
      if(i == currentFrame){
          hideLineChartMarkers(myLinechartList);
          //Disable the Linechart - TO CHECK
          myLinechartList.get(i).setClicked(true);
          myLinechartList.get(i).draw();
          addTitleIfClicked(myLinechartList.get(i));
          addTitleIfHover(myLinechartList.get(i));
      }
  }
  
  //Draw legend for key and mouse interaction
  pushStyle();
  textSize(12);
  fill(0);
  textAlign(LEFT);
  int legxPos = myLinechartList.get(0).getXPos() + myLinechartList.get(0).getWidth() + 50;
  int legyPos = 75;
  int legVerticalSpace = 25;
  text("- Basic Keyboard interaction legend:", legxPos, legyPos);
  for(int i = 0; i < myLinechartList.size();i++){
    //drawLegend(float xPos, float yPos, float Width, float Height)
      
    String message = "Press " + (i + 1)  + ": switch to this attribute "  + myLinechartList.get(i).getColumnX();
    
    text(message, legxPos, legyPos + legVerticalSpace * (i + 1));
       
  }
  
  text("- Mouse click/hover interaction legend:", legxPos, legyPos + legVerticalSpace + legVerticalSpace*myLinechartList.size());
  
  String message1 = "Click to simply show the red triangular";
  
  text(message1, legxPos, legyPos + legVerticalSpace * (myLinechartList.size() + 2));
  
  String message3 = "Hover to show the bar magnitude";
  
  text(message3, legxPos, legyPos + legVerticalSpace * (myLinechartList.size() + 3));
  
  
  // Restore previous drawing style
  popStyle();
  
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
           //If clicked, draw a triangle       
           currentScatterPlot.drawMarker(temp);
           
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
           //If mouse hovered, show a description text
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
      switch(key){
        case '1':  
            currentFrame = 0;
            break;
        case '2':  
            currentFrame = 1;
            break;
        case '3':  
            currentFrame = 2;
            break;
        case '4':  
            currentFrame = 3;
            break;
        default:
            println("Default key presss");
            break;
        
      }
    }
}

// loop over and unhide all markers
  private void unhideScatterplots(ArrayList<ScatterPlot> myList) {
    for(ScatterPlot s : myList) {
      if(s.getClicked() == false)
        s.setClicked(true);
    }
      
  }
  // loop over and hide all markers
  //To be enhanced to avoid code duplication
    private void hideMarkers(ArrayList<ScatterPlot> myList) {
      for(ScatterPlot s : myList) {
        if(s.getClicked() == true)
          s.setClicked(false);
      }
        
    }
    
    // loop over and hide all markers
    //To be enhanced to avoid code duplication
    private void hideLineChartMarkers(ArrayList<Linechart> myList) {
      for(Linechart s : myList) {
        if(s.getClicked() == true)
          s.setClicked(false);
      }
        
    }
    
    //To be enhanced to avoid code duplication
    private void hideBarChartMarkers(ArrayList<Barchart> myList) {
      for(Barchart s : myList) {
        if(s.getClicked() == true)
          s.setClicked(false);
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
 
 abstract void drawMarker(ScreenPosition p);
 
 abstract void setClicked(boolean state);
 
 abstract boolean getClicked();
 
  
  
  boolean mouseInside(){
     return (u0-clickBuffer < mouseX) && (u0+w+clickBuffer)>mouseX && (v0-clickBuffer)< mouseY && (v0+h+clickBuffer)>mouseY; 
  }
  
  abstract String getColumnX();
  
}
