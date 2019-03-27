import java.util.*;

Table myTable = null;
Frame myFrame = null;
Frame mySplom = null;
Frame myScatterplot = null;
Frame myLinechart = null;
Frame myBarchart = null;
Frame myPCP = null;

String fileName;

//int selectedPoint = -1;
HashSet<Integer> selectedPoints = new HashSet<Integer>();

int xStartPos = 30; 
int yStartPos = 30;

float THRESHOLD_INTERMEDIATE_SATM = 615;
float THRESHOLD_HIGH_SATM = 660;
float THRESHOLD_INTERMEDIATE_SATV = 0;
float THRESHOLD_HIGH_SATV = 0;
float THRESHOLD_INTERMEDIATE_ACT = 10;
float THRESHOLD_HIGH_ACT = 10;

void setup(){
   size(1200,700);  
   selectInput("Select a file to process:", "fileSelected");
  /** Development Purpose
   myTable = loadTable( "srsatact.csv", "header" );
   //myTable = loadTable( "srsatact_cut.csv", "header" );
   myTable = loadTable( "iris.csv", "header" );
   myScatterplot = new Scatterplot( myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
   myFrame = new splom( );
   myPCP = new PCP( );
   myLinechart = new Line( myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
   mySplom = new splom( );
   myBarchart =  new Bar(myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
   **/
    
}


void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    selectInput("Select a file to process:", "fileSelected");
  } else {
    println("User selected " + selection.getAbsolutePath());
    fileName = selection.getName();
    print(fileName);
    myTable = loadTable( selection.getAbsolutePath(), "header" );
    myFrame = new Scatterplot( myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
    myScatterplot = new Scatterplot( myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
   myFrame = new splom( );
   myPCP = new PCP( );
   myLinechart = new Line( myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
   mySplom = new splom( );
   myBarchart =  new Bar(myTable.getColumnTitle(0), myTable.getColumnTitle(1) );
  }
}



void draw(){
  background( 255 );
  
  if( myTable == null ) 
    return;
  
  if( myFrame != null ){
       //myFrame.setPosition( 100, 100, (width - 100)/2, height - 100);
       //myFrame.draw();
       //println("Inside myFrame");
       int buffer = 100;
       
       int numbUnitWidth = 4;
       int numbUnitLength = 4;
       
       int widthFactor = 2;
       int heightFactor = 2;
       
       //draw a function for title
       String title;
       if(fileName.equals("srsatact.csv"))
           title ="Predicting success of all Calvin College 2004 seniors";
       else   
           title ="Predicting analysis of IRIS data set";
       //Border of the textbox
       //rect(xStartPos, 0, width - buffer, yStartPos - 2);
       textAlign(CENTER,CENTER);    
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
       
       //draw a function for title
       String ins;
       ins ="*Interactions:\n - Select a point in the Scatterplot to view its details.\n"
       + "    Then the data point is highlighted it in all other views."
       + " User can also swap axes in PCP.\n";
       //Border of the textbox
       //rect(myScatterplot.getXPos(),  myPCP.getYPos() + myPCP.getHeight(), 
       //myScatterplot.getWidth(), buffer);
       
       textAlign(LEFT, CENTER);
       myFrame.drawTextOnScreen(myScatterplot.getXPos() + 5 , myPCP.getYPos() + myPCP.getHeight() + buffer/2,
       0, 12, ins);
       
       //rect(myLinechart.getXPos(),  myLinechart.getYPos() + myLinechart.getHeight(), 
       //mySplom.getWidth(), buffer);
       
       ins ="*Visual Encoding:\n - In Scatterplot, a colored star means your interested point.\n"
       + "E.g: In student dataset, the star means your performance.";
       
       textAlign(LEFT, CENTER);
       myFrame.drawTextOnScreen(myLinechart.getXPos() + 5,  myLinechart.getYPos() + myLinechart.getHeight() + buffer/3,
       0, 12, ins);
       
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
  //myScatterplot.mouseMoved();
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
    fill(50);
    stroke(0,0,0);
    //translate(x,y);
    rotate(rotate);
    //textAlign(CENTER,CENTER);
    text(text, u0 + x, v0 + y);
    
    popMatrix();
    
  }
  //End method draw text on screen
  
  
  boolean mouseInside(){
     return (u0-clickBuffer < mouseX) && (u0+w+clickBuffer)>mouseX && (v0-clickBuffer)< mouseY && (v0+h+clickBuffer)>mouseY; 
  }
  
  
}
