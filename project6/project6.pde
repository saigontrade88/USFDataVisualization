import java.util.*;

Table myTable = null;
Frame myFrame = null;

//int selectedPoint = -1;
HashSet<Integer> selectedPoints = new HashSet<Integer>();

void setup(){
   size(800,600);  
  //selectInput("Select a file to process:", "fileSelected");
   //myTable = loadTable( "srsatact.csv", "header" );
   myTable = loadTable( "srsatact_cut.csv", "header" );
    //myFrame = new Scatterplot( myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
    //myFrame = new splom( );
   // myFrame = new PCP( );
   myFrame = new Line( myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
}


void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    selectInput("Select a file to process:", "fileSelected");
  } else {
    println("User selected " + selection.getAbsolutePath());
    myTable = loadTable( selection.getAbsolutePath(), "header" );
    //myFrame = new Scatterplot( myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
    myFrame = new splom( );
   // myFrame = new PCP( );
  }
}


void draw(){
  background( 255 );
  
  if( myTable == null ) 
    return;
  
  if( myFrame != null ){
       myFrame.setPosition( 100, 100, width - 100, height - 100);
       myFrame.draw();
  }
  //noLoop();
}


void mousePressed(){
  myFrame.mousePressed();
}


void mouseReleased(){
  myFrame.mouseReleased();
}


void keyPressed(){
  switch( key ){
     //case '1': ((Scatterplot)myFrame).setAttributes( myTable.getColumnTitle(0), myTable.getColumnTitle(1) ); break;
     //case '2': ((Scatterplot)myFrame).setAttributes( myTable.getColumnTitle(1), myTable.getColumnTitle(2) ); break;
     //case '3': ((Scatterplot)myFrame).setAttributes( myTable.getColumnTitle(0), myTable.getColumnTitle(2) ); break;
  }
}
abstract class Frame {
  
  int u0,v0,w,h;
  int clickBuffer = 8;
     
  void setPosition( int u0, int v0, int w, int h ){
    this.u0 = u0;
    this.v0 = v0;
    this.w = w;
    this.h = h;
  }
  
  int getXPos(){
      return u0;
  }
  
  int getYPos(){
      return v0;
  }
  
  int getWidth(){
      return w;
  }
  
  int getHeight(){
      return h;
  }
  
  abstract void draw();
  void mousePressed(){ }
  void mouseReleased(){ }
  
  
  boolean mouseInside(){
     return (u0-clickBuffer < mouseX) && (u0+w+clickBuffer)>mouseX && (v0-clickBuffer)< mouseY && (v0+h+clickBuffer)>mouseY; 
  }
  
  
}
