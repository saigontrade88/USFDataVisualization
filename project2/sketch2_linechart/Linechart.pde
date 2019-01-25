

class Linechart extends Frame {

  Table data;
  String useColumn;

  Linechart( Table _data, String _useColumn ) {
    data = _data;
    useColumn = _useColumn;
  }
  
  void setColumn( String _useColumn ){
    useColumn = _useColumn;
  }

  void draw() {  
      
      drawXAxis();
      
      drawYAxis();
           
      drawLines();    
  }
  
  void drawXAxis(){
    
     String myYear; 
         
     float xPos;
     
     float minYr_xPos = map(0, 0, data.getRowCount(), 100, width-100);
     
     //println(minYr_xPos);
     
     float maxYr_xPos = map(data.getRowCount(), 0, data.getRowCount(), 100, width-100);
     
     textAlign(CENTER);
     
     float deltaC = 1.2;
      
     line(minYr_xPos, 300, maxYr_xPos, 300);
    
     for (int row = 0; row < data.getRowCount(); row++) {  
       
        myYear = this.data.getString(row, 0);
        
        xPos = map(row, 0, data.getRowCount(), 100, width-100);
        
        text(myYear, xPos, 315);
        
        line(xPos, 300 - deltaC, xPos, 300 + deltaC);
     }
       text("Year", (minYr_xPos + maxYr_xPos)/2, 340);
  }
  void drawYAxis(){
    // 2004; 5.70;90; REP
    // 2008; 5.00;12; DEM
    float maxGPA = 10.0;
    
    float minGPA = 0.0;
    
    float numSpace = ( maxGPA - minGPA )/data.getRowCount(); 
    
    float maxGPA_yPos = map(10, 3, 10, height/2, 100);
    
    float minGPA_yPos = map(3, 3, 10, height/2, 100);
    
    //float yPos;
    float yPos;
    
    // Line and labels for Y axis
    textAlign(RIGHT);
    
    line(100, minGPA_yPos, 100, maxGPA_yPos);
    
    float deltaC = 1.2;
    
    for (int i = 3; i < 11; i++) {
        yPos = map(i, 3, 10, height/2, 100);
      //println("tickMark_yPos = " + yPos);
        text (i, 90, yPos);
         
        line(100 - deltaC, yPos, 100 + deltaC, yPos);
    }
    text("GPA", 75, (maxGPA_yPos + minGPA_yPos)/2);    
    
  }
  void drawTitle(){
    
  }
  
  
  void drawLines(){
    
    float[] xPosArray = new float[data.getRowCount()];
      
    float[] yPosArray = new float[data.getRowCount()];
    
    String myYear;
    
    float myGpa_Score;
    
    float xPos;
    
    float yPos;
    
    for (int row = 0; row < data.getRowCount(); row++) {
        
        myYear = this.data.getString(row, 0);
        
        myGpa_Score = this.data.getFloat(row, 1);
        
        xPos = map(row, 0, data.getRowCount(), 100, width-100);
        
        yPos = map(myGpa_Score, 3, 10, height/2, 100);
        
        xPosArray[row] = xPos;
        
        yPosArray[row] = yPos;
        
        //println(myYear + "=" + xPos + "/" + myGpa_Score + "=" + yPos);
        //println("-----------------------");
       // println(myGpa_Score + "," + y);
        stroke(palette[1]);
        // line(x, y, x, 150);
        noStroke();
        
        fill(palette[1]);
        
        int d = 8;
        
        ellipse(xPos, yPos, d, d);
        
        //text(myYear, x, 300);
     }
     // Connecting the dots
     int xPrevIndex = 0;
     
     int yPrevIndex = 0;
     
     for (int row = 1; row < data.getRowCount(); row++) {
         //println(xPosArray[row] +" " + yPosArray[row] );
         stroke(palette[1]);
         
         line(xPosArray[xPrevIndex], yPosArray[yPrevIndex], xPosArray[row], yPosArray[row]);
         
         xPrevIndex = row;
         
         yPrevIndex = row;
     }
  }
  
  void drawLabels(){
  
  }
  
  void drawGridLines(){
  }

  void mousePressed() {  }

  void mouseReleased() {   }
  
}
