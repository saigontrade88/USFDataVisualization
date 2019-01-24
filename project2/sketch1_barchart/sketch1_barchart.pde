//#import Barchart.pde

Table myTable = null;
Frame myFrame = null;

// Initialize bar chart object to be used by setup() and draw()
Barchart myFirstBarChart = null;

///** Bar Chart
//  * An application .
//  * Author: 
//  * @author Long Dang
//  * Date: January 16, 2019
//  * */
  
void setup(){
  
  
   // Step 1: Import data
   // Data description:
   // YEAR; GPA ;ACT;PARTY
   // 1992; 7.30;88; DEM
   // 1996; 5.60;43; DEM
   // 2000; 4.00;76; REP
   // 2004; 5.70;90; REP
   // 2008; 5.00;12; DEM
   // 2012; 8.30;14; DEM
   // 2016; 4.90;50; REP
   
  // myTable = loadTable("Input_Data.csv", "header");
   
   
   
   //******************************************
   // Step 2: Set up the sketch to be 600x600
   // The OPENGL argument indicates to use the 
   // Processing library's 2D drawing
   // int sWidth = 600;
   // int sHeight = 600;//int sWidth = 600;
   // int sHeight = 600;
   
     size(500,400);  
    
    selectInput("Select a file to process:", "fileSelected");
     
     
     
    
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    selectInput("Select a file to process:", "fileSelected");
  } else {
    println("User selected " + selection.getAbsolutePath());
    
    myTable = loadTable( selection.getAbsolutePath(), "header" );   
    
    myFirstBarChart = new Barchart( myTable, myTable.getColumnTitles()[0] );
  //  println(myTable.getColumnCount() + " total columns in table");
     
     println(myFirstBarChart.getNumberRows() + " total rows in table");
     
     println(myFirstBarChart.getNumberFields() + " total fields in table");
    
     myFirstBarChart.setColumn(myTable.getColumnTitles()[1]);
  }
}


void draw(){
  
  //set the window background color to green
 // background(0, 200, 0);
  
 // if( myTable == null ) 
 //   return;
  
  if( myFrame != null ){
       myFrame.setPosition( 0, 0, width, height );
     //  println("Hello Long");
       myFrame.draw();
  }
  // Draw the bar chart in the sketch
  // barChart.draw(15,15,width-30,height-30); 
  
    
   
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
