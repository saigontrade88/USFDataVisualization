
Table myTable = null;
Frame myFrame = null;

color[] dessert = {#9F9694, #791F33, #BA3D49, #F1E6D4, #E2E1DC};
color[] palette = dessert;


void setup(){
   // YEAR; GPA ;ACT;PARTY
   // 1992; 7.30;88; DEM
   // 1996; 5.60;43; DEM
   // 2000; 4.00;76; REP
   // 2004; 5.70;90; REP
   // 2008; 5.00;12; DEM
   // 2012; 8.30;14; DEM
   // 2016; 4.90;50; REP
  size(600,600);  
  selectInput("Select a file to process:", "fileSelected");
}


void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    selectInput("Select a file to process:", "fileSelected");
  } else {
        println("User selected " + selection.getAbsolutePath());
        
        myTable = loadTable( selection.getAbsolutePath(), "header" );
        
        myFrame = new Linechart( myTable, myTable.getColumnTitles()[0] );
        
        // TODO: create object
        // Read year

    }
}


void draw(){
  
  noCursor();
  
  
  
  background( palette[0] );
  
  if( myTable == null ) 
    return;
  
  if( myFrame != null ){
    //Draw the line chart
       myFrame.setPosition( 0, 0, width, height );
       myFrame.draw();
       textAlign(CENTER);
       text("My first line chart", width/2, 20);
  }
  
  noLoop();
}


void mousePressed(){
  myFrame.mousePressed();
}


void mouseReleased(){
  myFrame.mouseReleased();
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
  
  
  
  boolean mouseInside(){
     return (u0-clickBuffer < mouseX) && (u0+w+clickBuffer)>mouseX && (v0-clickBuffer)< mouseY && (v0+h+clickBuffer)>mouseY; 
  }
  
  
}
