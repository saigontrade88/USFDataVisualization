

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
  
  /**
  * Returns the array containing all selected data points 
  * @param _useColumn
  * @return the array
  */

  float[] getDataValueArray(String _useColumn){
    
    float[] dataArray = new float[data.getRowCount()];
    
    for (int row = 0; row < data.getRowCount(); row++) {
        
        dataArray[row] = this.data.getFloat(row, this.data.getColumnIndex(_useColumn));
    }
    
    return dataArray;
    
  }
  
  /**
  * Select the minimum which is used for scaling   
  * @param the array containing all selected data points 
  * @return the minimum
  */
  
  float getMinArray(float[] dataValueArray){
      return min(dataValueArray);
  }
  
  /**
  * Select the maximum which is used for scaling   
  * @param the array containing all selected data points 
  * @return the maximum
  */
  
  float getMaxArray(float[] dataValueArray){
      return max(dataValueArray);
  }

  void draw() {  
    
      drawTitle("GPA Across The Year");
      
      //drawYAxis();
      drawYAxis(this.useColumn);
           
     // drawLines();  
      drawLines("YEAR", this.useColumn); 
      
      //drawXAxis();
      drawXAxis("YEAR", this.useColumn);
  }
  
  /**
  * Draw the horizontal axis   
  * @param the selected categorical variable and the quantitative variable 
  */
  void drawXAxis(String _categoricalColumn, String _useColumn){
      
     // The vertical axis's position information used for interconneting the horizontal line and the vertical line
          
     float yAxis_minValue = getMinArray(getDataValueArray(_useColumn));
     
     float yAxis_maxValue = getMaxArray(getDataValueArray(_useColumn));
    
     // Scaled min values       
     float minValue_yPos = map(yAxis_minValue, yAxis_minValue, yAxis_maxValue, height/2, 100);
     
     // The horizontal axis's x position -- Intersection between the horizontal and vertical axis
     float xAxis_yPos = minValue_yPos;
     
     // The label's y position
     float xLabel_yPos = minValue_yPos + 40;
    
     // Each year's x position    
     float xPos;
     
     // The first year'x position
     float minYr_xPos = map(0, 0, data.getRowCount(), 100, width-100);
     
     //println(minYr_xPos);
     
     // The last year'x position
     float maxYr_xPos = map(data.getRowCount(), 0, data.getRowCount(), 100, width-100);
     
     textAlign(CENTER);
     
     // Factor used to draw the tick mark
     float deltaC = 1.2;
      
     line(minYr_xPos, xAxis_yPos, maxYr_xPos, xAxis_yPos);
     
     // Draw each data value on the horizontal axis
     // Furtheremore, draw the tick marks 
     for (int row = 0; row < data.getRowCount(); row++) {  
       
        String myCategoricalColumn = this.data.getString(row, this.data.getColumnIndex(_categoricalColumn));
        
        xPos = map(row, 0, data.getRowCount(), 115, width-115);
        
        text(myCategoricalColumn, xPos, xAxis_yPos + 12*deltaC);
        
        line(xPos, xAxis_yPos - deltaC, xPos, xAxis_yPos + deltaC);
     }
     
     // Draw the label according to the min and max values's y positions
     text(_categoricalColumn, (minYr_xPos + maxYr_xPos)/2, xLabel_yPos);
  }
  
   /**
  * Draw the vertical axis   
  * @param the quantitative variable 
  */
  void drawYAxis(String _useColumn){
    // 2004; 5.70;90; REP
    // 2008; 5.00;12; DEM
    
    // 10% is allocated for label
    float factor = 0.1; 
    
    // The vertical axis's x position
    float yAxis_xPos = this.getXPosition() + factor * this.getWidth();
    
    // The corresponding label's x position - in the middle of the 10% of the sketch
    float label_xPos = this.getXPosition() + 0.5*factor * this.getWidth();
    
    //Factor used to draw the tick marks
    float deltaC = 1.2;
    
    // The maximum value of the selected data range    
    float maxValue = getMaxArray(getDataValueArray(_useColumn));
    
    // The minimum value of the selected data range
    float minValue = getMinArray(getDataValueArray(_useColumn));
    
    // Scaled min and max values    
    float maxValue_yPos = map(maxValue, minValue, maxValue, height/2, 100);
    
    float minValue_yPos = map(minValue, minValue, maxValue, height/2, 100);
    
    //y Axis position of tick marks;
    float yPos;
    
    // Line and labels for Y axis
    textAlign(RIGHT);
    
    // Draw the vertical line
    line(yAxis_xPos, minValue_yPos, yAxis_xPos, maxValue_yPos);
    
    // Draw the values and the corresponding tick marks
    for (int i = int(minValue); i < int(maxValue) + 1; i++) {
        yPos = map(i, minValue, maxValue, height/2, 100);
      //println("tickMark_yPos = " + yPos);
        text (i, this.getXPosition() + factor * this.getWidth(), yPos);
         
        line(yAxis_xPos - deltaC, yPos, yAxis_xPos + deltaC, yPos);
    }
    
    // Draw the label according to the min and max values's y positions
    text(_useColumn, label_xPos, (maxValue_yPos + minValue_yPos)/2);    
    
  }
  
  void drawTitle(String myChartTitle){
    
    text(myChartTitle, this.getWidth()/2, 0.05 * this.getHeight());   
    
  }
  
  
  void drawLines(String _categoricalColumn, String _useColumn){
    
    // Initialize an array containing data value
    float[] dataArray = new float[data.getRowCount()];
    
    dataArray = getDataValueArray(_useColumn);
    
    float maxValue = max(dataArray);
    
    float minValue = min(dataArray);
      
    // Initialize arrays containing coordinate information of each data point
    float[] xPosArray = new float[data.getRowCount()];
      
    float[] yPosArray = new float[data.getRowCount()];
    // Scaled coordinates of each data point  
    float xPos, yPos;
        
    for (int row = 0; row < data.getRowCount(); row++) {
        
        String myCatValue = this.data.getString(row, this.data.getColumnIndex(_categoricalColumn));
        
        Float myQuantValue = this.data.getFloat(row, this.data.getColumnIndex(_useColumn));
        
        xPos = map(row, 0, data.getRowCount(), 115, width-115);
        
        yPos = map(myQuantValue, minValue, maxValue, height/2, 115);
        
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
