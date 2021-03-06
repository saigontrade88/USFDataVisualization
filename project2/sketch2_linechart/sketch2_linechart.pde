
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
  // Step 01: Draw a sketch
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
        
        String myFirstVariable =  "GPA";
        
       // myFrame = new Linechart( myTable, myTable.getColumnTitles()[0] );
        
        // Add constructor with color/shape, but how about the scale?
        // Ex: myFrame = new Linechart( myTable, myFirstVariable, "Yellow" );
        // Ex: myFrame = new Linechart( myTable, myFirstVariable, Square );
        myFrame = new Linechart( myTable, myFirstVariable );
        
        // Step 02: Choose data points
        // Select the variable
        
        
        // Choose the corresponding data values from Step 01 above
        
        // If can not find the selected variable, returns error message
        
        // Step 03: Draw the line chart
        
        // Select and draw the title
        
        // Draw the y-Axis lines 
        
        // Draw the data points
        
        // Step 04: Add embellishments
        
        // Select the categorical variables, e.g: time period values, or date values
        
        // Choose the corresponding data values from the above step
        
        // Draw the x-Axis  
        
        // Draw the labels
        
        // Draw the legends

    }
}


void draw(){
  
  noCursor();
  
  
  
  background( palette[0] );
  
  if( myTable == null ) 
    return;
  
  if( myFrame != null ){
    //Draw the line chart
       myFrame.setPosition( 50, 50, width - 50 , height -50 );
       
       myFrame.draw();
       
       textAlign(CENTER);
       
       //text("My first line chart", width/2, 20);
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
  
  int getXPosition(){
    return u0;
  }
  
  
  int getYPosition(){
    return v0;
  }
  
  int getWidth(){
    return this.w;
  }
  
  int getHeight(){
    return this.h;
  }
  
  abstract void draw();
    
  void mousePressed(){ }
  void mouseReleased(){ }
  
  
  
  boolean mouseInside(){
     return (u0-clickBuffer < mouseX) && (u0+w+clickBuffer)>mouseX && (v0-clickBuffer)< mouseY && (v0+h+clickBuffer)>mouseY; 
  }
  
  
}
