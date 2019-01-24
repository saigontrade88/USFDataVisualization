

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
      // Draw the y axis: Draw the GPA_score's points
      float[] xPosArray = new float[myTable.getRowCount()];
      
      float[] yPosArray = new float[myTable.getRowCount()];
      
      float x;
      
      float y;
      
      String myYear;
      
      float myGpa_Score;
           
      // Line and labels for X axis

     textAlign(CENTER);
      
     line(100, 250, width - 100, 250);
     
     text("Year", 325, 445);
     
     // Draw
      
      for (int row = 0; row < myTable.getRowCount(); row++) {
        
        myYear = this.data.getString(row, 0);
        
        myGpa_Score = this.data.getFloat(row, 1);
        
        x = map(row, 0, myTable.getRowCount(), 100, width-100);
        
        y = map(myGpa_Score, 12, 90, height/4, 0);
        
        xPosArray[row] = x;
        
        yPosArray[row] = y;
        
        //println(myYear + "," + x);
        //println("-----------------------");
        //println(myGpa_Score + "," + y);
        stroke(palette[1]);
        // line(x, y, x, 150);
        noStroke();
        
        fill(palette[1]);
        
        int d = 10;
        
        ellipse(x, y, d, d);
        
        text(myYear, x, 300);
     }
     // Connecting the dots
     int xPrevIndex = 0;
     
     int yPrevIndex = 0;
     
     for (int row = 1; row < myTable.getRowCount(); row++) {
         //println(xPosArray[row] +" " + yPosArray[row] );
         stroke(palette[1]);
         
         line(xPosArray[xPrevIndex], yPosArray[yPrevIndex], xPosArray[row], yPosArray[row]);
         
         xPrevIndex = row;
         
         yPrevIndex = row;
     }
     
     
     
  }
  
  void drawXAxis(){
  
  }
  void drawYAxis(){
    
  }
  void drawTitle(){
    
  }
  void drawPoints(){
    
  }
  
  void drawLines(){
  
  }
  
  void drawLabels(){
  
  }
  
  void drawGridLines(){
  }

  void mousePressed() {  }

  void mouseReleased() {   }
  
}
