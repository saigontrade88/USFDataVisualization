import java.util.*;

Table myTable = null;
Frame myFrame = null;
Frame mySplom = null;
Frame myScatterplot = null;
Frame myLinechart = null;
Frame myBarchart = null;
Frame myPCP = null;

//int selectedPoint = -1;
HashSet<Integer> selectedPoints = new HashSet<Integer>();

int xStartPos = 30; 
int yStartPos = 30;

float THRESHOLD_INTERMEDIATE_SATM = 615;
float THRESHOLD_HIGH_SATM = 660;
float THRESHOLD_INTERMEDIATE_SATV = 615;
float THRESHOLD_HIGH_SATV = 650;
float THRESHOLD_INTERMEDIATE_ACT = 10;
float THRESHOLD_HIGH_ACT = 10;

void setup(){
   size(1200,700);  
  //selectInput("Select a file to process:", "fileSelected");
   myTable = loadTable( "srsatact.csv", "header" );
   //myTable = loadTable( "srsatact_cut.csv", "header" );
   //myTable = loadTable( "ketchup.csv", "header" );
   myScatterplot = new Scatterplot( myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
   myFrame = new splom( );
   myPCP = new PCP( );
   myLinechart = new Line( myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
   mySplom = new splom( );
   myBarchart =  new Bar(myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
    
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
       //myFrame.setPosition( 100, 100, (width - 100)/2, height - 100);
       //myFrame.draw();
       
       int buffer = 100;
       
       int numbUnitWidth = 4;
       int numbUnitLength = 4;
       
       int widthFactor = 2;
       int heightFactor = 2;
       
       //draw a function for title
       String title;
       title ="Predicting success of all Calvin College 2004 seniors";
       //Border of the textbox
       rect(xStartPos, 0, width - buffer, yStartPos - 2);
           
       myFrame.drawTextOnScreen((width - buffer)/2, (yStartPos - 2)/2,
       0, 16, title);
       
       //Vertical direction
       //draw the Scatterplot
       myScatterplot.setPosition(xStartPos, yStartPos, 
        widthFactor*(width - buffer)/numbUnitWidth, heightFactor*height/numbUnitLength);
        myScatterplot.draw();
       
       //Parallel coordinate based on Scatterplot position
       myPCP.setPosition(xStartPos, myScatterplot.getYPos() + myScatterplot.getHeight(), 
       myScatterplot.getWidth(), myScatterplot.getHeight() - buffer);
       myPCP.draw();
       
       //Splom based on Scatterplot position
       mySplom.setPosition(myScatterplot.getXPos() + myScatterplot.getWidth(), yStartPos, 
       (numbUnitWidth - widthFactor)*(width - buffer)/numbUnitWidth, heightFactor*height/numbUnitLength);
       mySplom.draw();
       
       //Line chart based on Scatterplot position
       myLinechart.setPosition(myScatterplot.getXPos() + myScatterplot.getWidth(), myScatterplot.getYPos() + myScatterplot.getHeight(), 
       myScatterplot.getWidth()/2, myPCP.getHeight());
       myLinechart.draw();
       
       //Bar chart based on line chart position
       myBarchart.setPosition(myLinechart.getXPos() + myLinechart.getWidth(), myScatterplot.getYPos() + myScatterplot.getHeight(),
       myScatterplot.getWidth()/2, 
       myPCP.getHeight());
       myBarchart.draw();
       
  }
  //noLoop();
}


void mousePressed(){
  //myFrame.mousePressed();
  myScatterplot.mousePressed();
  myLinechart.mousePressed();
  myBarchart.mousePressed();
  myPCP.mousePressed();
}


void mouseReleased(){
  myFrame.mouseReleased();
  myScatterplot.mouseReleased();
  myLinechart.mouseReleased();
  myBarchart.mouseReleased();
  myPCP.mouseReleased();
}

void mouseMoved(){
  myScatterplot.mouseMoved();
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
  void mouseMoved(){ }
  
  void drawTextOnScreen(float x, float y, float rotate, int textSize, String text)
  {
    pushMatrix();
    
    textSize(textSize);
    fill(0,51,0);
    stroke(0,0,0);
    //translate(x,y);
    rotate(radians(rotate));
    textAlign(CENTER,CENTER);
    text(text,x, y);
    
    popMatrix();
    
  }
  //End method draw text on screen
  
  
  boolean mouseInside(){
     return (u0-clickBuffer < mouseX) && (u0+w+clickBuffer)>mouseX && (v0-clickBuffer)< mouseY && (v0+h+clickBuffer)>mouseY; 
  }
  
  
}
