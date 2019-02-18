
Table myTable = null;
Frame myFrame = null;
ScatterPlot myFirstScatterPlot = null;

ArrayList<ScatterPlot> myScatterPlotList = null;

color[] dessert = {#9F9694, #791F33, #BA3D49, #F1E6D4, #E2E1DC};
color[] palette = dessert;

float THRESHOLD_INTERMEDIATE_SATM = 615;
float THRESHOLD_HIGH_SATM = 660;
float THRESHOLD_INTERMEDIATE_SATV = 615;
float THRESHOLD_HIGH_SATV = 650;

void setup() {
  
  size(600, 600); 
  
  myScatterPlotList = new ArrayList<ScatterPlot>();
  
  selectInput("Select a file to process:", "fileSelected");
  
  //myTable = loadTable( "srsatact.csv", "header" );
  
  //myTable.getColumnCount()
  

  
}


void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    selectInput("Select a file to process:", "fileSelected");
  } else {
    println("User selected " + selection.getAbsolutePath());
    myTable = loadTable( selection.getAbsolutePath(), "header" );
    
    // TODO: create objects
    for(int i = 0; i < myTable.getColumnCount();i++){
       for(int j = 0; j < myTable.getColumnCount(); j++){
           //print("i= " + i + "origin is= " + i*width/4);
           //ScatterPlot( Table _data, String _useColumnX, String _useColumnY, String _chartName, int _xPos, int _yPos, int _sWidth, int _sHeight) 
           ScatterPlot temp = new ScatterPlot( myTable, myTable.getColumnTitles()[i], myTable.getColumnTitles()[j],"" , j*width/4, 10 + i*height/5, width/5, height/5);
           myScatterPlotList.add(temp);
     }
  }
    
  }
}


void draw() {
  background( 255 );

  if ( myTable == null ) 
    return;
    
   for(int i = 0; i < myScatterPlotList.size();i++){
       myScatterPlotList.get(i).draw();
   }
      
  }



void mousePressed() {
  //myFrame.mousePressed();
}


void mouseReleased() {
  //myFrame.mouseReleased();
}



abstract class Frame {

  int u0, v0, w, h;
  int clickBuffer = 2;

  void setPosition( int u0, int v0, int w, int h ) {
    this.u0 = u0;
    this.v0 = v0;
    this.w = w;
    this.h = h;
  }

  abstract void draw();
  void mousePressed() {
  }
  void mouseReleased() {
  }


  boolean mouseInside() {
    return (u0-clickBuffer < mouseX) && (u0+w+clickBuffer)>mouseX && (v0-clickBuffer)< mouseY && (v0+h+clickBuffer)>mouseY;
  }
}
