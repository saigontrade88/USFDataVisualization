import java.util.ArrayList;

float []myArrayBuffer = {69.5, 60, 1.05, 0.38}; // 1 standard deviation

//float myYBuffer = 60;

public static int TRI_SIZE = 5; 


class ScatterPlot extends Frame {

  Table data;// Table contains x-data, y-data
  String useColumnX, useColumnY, chartName;
  int x_pos, y_pos; // Refer to the top left corner of the scatter plot
  int sWidth; // Scatterplot chart is a rectangular canvas with the corresponding width and height 
  int sHeight; 
  //Build the scale
  float  myMin_XValue;
  float  myMax_XValue;
  float  myMin_YValue;
  float  myMax_YValue;
  //float[]  myYValueArray;
  ArrayList<PointEntry> myList; // to store x-,y- data from raw data
  ArrayList<ScreenPosition> myScatterPoints; 
  boolean clicked;
  //boolean selected;

  ScatterPlot( Table _data, String _useColumnX, String _useColumnY, String _chartName, int _xPos, int _yPos, int _sWidth, int _sHeight) {
    data = _data;
    useColumnX = _useColumnX;
    useColumnY = _useColumnY;
    chartName = _chartName;
    
    x_pos  = _xPos;
    y_pos  = _yPos;
    
    sWidth = _sWidth;
    sHeight = _sHeight;
    
    clicked = false;
    
    //selected = false;
    
    myMin_XValue = findMinValue(_data.getFloatColumn(_useColumnX));
    myMax_XValue = findMaxValue(_data.getFloatColumn(_useColumnX));
    myMin_YValue = findMinValue(_data.getFloatColumn(_useColumnY));
    myMax_YValue = findMaxValue(_data.getFloatColumn(_useColumnY));
      
    //println("row count: "+_data.getRowCount());
    
    //println("min X: "+ myMin_XValue);
    //println("max X: "+ myMax_XValue);
    //println("min Y: "+ myMin_YValue);
    //println("max Y: "+ myMax_YValue);
    
    myList = new ArrayList<PointEntry>();
    
    createList();
    
    //println("My original size list is = " + myList.size());
    
    myScatterPoints = new ArrayList<ScreenPosition>();
    
    createMap();
    
    //listBigValue(_data.getFloatColumn(_useColumnX), 1.2);
    
    //listBigValues(myList, 2.35);
    
    //getClosest(myList, new PointEntry(1.19, 1.36), 2);
    
   
  }

  // Getter method for clicked field
  public boolean getClicked() {
    return clicked;
  }
  
  // Setter method for clicked field
  public void setClicked(boolean state) {
    clicked = state;
  }
  
  //Drawing method for scatterplot
   void draw() {
     if(clicked == true){
     
          //println("Draw the scatterplot");
          pushMatrix();
      
          //(0,0) - the origin point
          translate(x_pos, y_pos);
      
          //fill(255);
      
          //rect(0,0,sWidth, sHeight);
          
          fill(0);
          
          drawTitle();
          
          drawYAxis(this.useColumnY, 0.0f);
      
          drawXAxis(this.useColumnX, 0.0f);
      
          drawPoints(this.useColumnX, this.useColumnY, 0.0f, 0.0f);
          
          popMatrix();
     }
     

  } 
  
  /*
  * Create a list containing (x actual value, y actual value)
  */
  
  void createList() { 
    int xIndex = this.data.getColumnIndex(useColumnX);
    int yIndex = this.data.getColumnIndex(useColumnY);
    for (TableRow row : data.rows())
    {
      float quantVar1 = row.getFloat(xIndex);
      float quantVar2 = row.getFloat(yIndex);
      //println(quantVar2);
      PointEntry temp = new PointEntry(quantVar1, quantVar2);
      myList.add(temp);
    }
    //print(myList.size());
    
    /*for (int k=1; k < myList.size(); k++) {
        println(myList.get(k).getXVal() - myList.get(k-1).getXVal());
    }*/
    
  }
  /**
  *  Find the maximum value
  *
  * @param an array containing values of the selected column
  * @return the maximum data value
  */

  float findMaxValue(float[] _useCol) {
   // if ( (_useColumn != useColumnX) &&  (_useColumn != useColumnY))
   //   return -1000.0f;

    float maxValue = _useCol[0];

    for (int k=1; k < _useCol.length; k++) {
      if (maxValue < _useCol[k])
        maxValue = _useCol[k];
    }
    return maxValue;
  }
  
  /**
  *  Find the minimum value
  *
  * @param an array containing values of the selected column
  * @return the minimum data value
  */
  float findMinValue(float[] _useCol) {
    
    float minValue =_useCol[0];

    for (int k=1; k < _useCol.length; k++) {
      if (minValue > _useCol[k])
        minValue = _useCol[k];
    }
    return minValue;
  }
  
  /**
  * Find the all big values exceeding a certain value
  *
  * @param an array containing values of the selected column, a predefined magnitude
  * 
  */
  
  void listBigValues(float[] _useCol, float myThreshold){
      
      for (int k=0; k < _useCol.length; k++) {
          if (_useCol[k] > myThreshold)
            println(_useCol[k]);
        }
        
  }
  /**
  *  Create a list containing all the actual points satisfying a magnitude
  *
  * @param an array containing values of the selected column, a predefined magnitude
  * 
  */
  ArrayList<PointEntry> filterByTotalMagnitudes(ArrayList<PointEntry> PointList, float totalMin){
      ArrayList<PointEntry> answer = new ArrayList<PointEntry>();
      for(PointEntry p : PointList){
          float totalValue = p.getXVal() + p.getYVal(); 
          if(totalValue >= totalMin){
              answer.add(p);
          }
      }
      return answer;
  }
  /**
  *  Create a list containing all the actual points closest to a selected point
  *
  * @param an array list containing all points on the skatterplot, a selected point, e.x: the minimum point
  * 
  */
  ArrayList<PointEntry> getClosest(ArrayList<PointEntry> PointList, PointEntry currPoint, int howMany){ //<>//
      //Create a copy version to avoid changing the ArrayList PointList    
      ArrayList<PointEntry> copy = new ArrayList<PointEntry>(PointList);
      ArrayList<PointEntry> answer = new ArrayList<PointEntry>();
      int minIndex = 0;
      for(int j = 0; j < howMany; j++){ 
          for(int i = 1; i < copy.size(); i++){
              PointEntry p = copy.get(i);
              if(p.distanceTo(currPoint) < copy.get(minIndex).distanceTo(currPoint))
                  minIndex = i;
          }
          answer.add(copy.get(minIndex));
          copy.remove(minIndex);
      }
      //println(answer.size());
      //println(answer.get(0).toString());
      //println(answer.get(1).toString());
      return answer;    
  }
  
  /**
  * Find the all big values exceeding a certain value
  *
  * @param an array list containing values of the two selected columns, a predefined total magnitude
  * 
  */
  void listBigValues(ArrayList<PointEntry> PointList, float myThreshold){
      ArrayList<PointEntry> bigList = filterByTotalMagnitudes(PointList, myThreshold);
      for (PointEntry p : bigList) {
          println(p.toString());    
      }
        
  }
  /**
  * Create a list containing the screen positions
  *
  * @param:
  * @return the array list
  */  
  void createMap(){
    
     for (int k=0; k < myList.size(); k++) {

        float xPos;
  
        float yPos;
        
        float _myXBuffer = 0.0;
        
        float _myYBuffer = 0.0;
        
        // use map function to scale the input data values
  
        xPos = map(myList.get(k).getXVal(), myMin_XValue - _myXBuffer, myMax_XValue+ _myXBuffer, 10, this.sWidth);
  
        yPos = map(myList.get(k).getYVal(), myMin_YValue - _myYBuffer, myMax_YValue + _myYBuffer, this.sHeight -20, 10);
          
        ScreenPosition temp = new ScreenPosition(myList.get(k), xPos, yPos);
  
        this.myScatterPoints.add(temp);
      
     }
  }

  void drawYAxis(String _useColumnY, Float myBuffer) {
    
    // Used to find the scale unit; 
    int binCount = 5;
    // 10% is allocated for label
    float factor = 0.1; 

    //Factor used to draw the tick marks
    float deltaC = 1.2;
    
    float scale_unit = (myMax_YValue - myMin_YValue)/binCount;

    // Scaled min and max values    
    //float maxValue_yPos = map(maxValue, myMin_YValue - myBuffer, myMax_YValue + myBuffer, this.sHeight - 20, 10);
    
    //float minValue_yPos = map(minValue, myMin_YValue - myBuffer, myMax_YValue + myBuffer, this.sHeight - 20, 10);
    
   // println("Drawing y scale: maxValue = " + maxValue + " maxValue_yPos = " + maxValue_yPos);
   // println("Drawing y scale: minValue = " + minValue + " minValue_yPos = " + minValue_yPos);
    
    // Line and labels for Y axis
    textAlign(RIGHT);

    // Draw the vertical line
    line(10, 10, 10, this.sHeight - 20);
    
   //println(this.x_pos + "," + this.y_pos+ "," + this.x_pos+ "," + maxValue_yPos);
  //println(int(minValue - myBuffer));
  //println(int(maxValue + myBuffer) + 1);
  
  
  float tickMark;
    // Draw the values and the corresponding tick marks
    for (int i = 0;i <= binCount; i++) {
      //tick mark's y position
      float yPos;
      //tick mark's actual value
      tickMark = myMin_YValue + i*scale_unit;
      //println(tickMark);
      yPos = map(tickMark, myMin_YValue - myBuffer, myMax_YValue + myBuffer, this.sHeight -20, 10);
      //println("tickMark = " + tickMark + " tickMark_yPos = " + yPos);
      String num = String.format ("%,.2f",tickMark); 
      text (num, 0, yPos);
      line( 10-deltaC, yPos, 10+deltaC, yPos);
    }

    // Draw the label according to the min and max values's y positions
    text(_useColumnY, 35, 5);
  }
 
  void drawXAxis(String _useColumnX, Float myBuffer) {
   
    // Used to find the scale unit; 
    int binCount = 5;
    //Factor used to draw the tick marks
    float deltaC = 1.5;
  
    float scale_unit = (myMax_XValue - myMin_XValue)/binCount;

    //println(maxValue);

    // Scaled min and max values    
   // float maxValue_xPos = map(maxValue, minValue - myBuffer, maxValue + myBuffer, 10, this.sWidth);

   // float minValue_xPos = map(minValue, minValue - myBuffer, maxValue + myBuffer, 10, this.sWidth);


    // Line and labels for Y axis
    textAlign(CENTER);

    // Draw the horizontal line
    line(10, this.sHeight - 20, this.sWidth, this.sHeight - 20);

    //println(this.x_pos + "," + this.y_pos+ "," + maxValue_xPos + "," + this.y_pos);
     float tickMark;
    // Draw the values and the corresponding tick marks
     for (int i = 0;i <= binCount; i++) {
      //tick mark's x position 
      float xPos;
      //tick mark's actual values
      tickMark = myMin_XValue + i*scale_unit;
      
      xPos = map(tickMark, myMin_XValue - myBuffer, myMax_XValue + myBuffer, 10, this.sWidth);
      //println("tickMark_yPos = " + yPos);
      
       String num = String.format ("%,.2f",tickMark); 
      
      text (num, xPos, this.sHeight);

      line(xPos, this.sHeight - 20 - deltaC, xPos, this.sHeight - 20 + deltaC);
    }

    // Draw the label according to the min and max values's y positions
    text(_useColumnX, sWidth, this.sHeight - 25);
  }
  
  void drawPoints(String _useColumnX, String _useColumnY, float _myXBuffer, float _myYBuffer) {

    for (int k=0; k < myScatterPoints.size(); k++) {

      int d = 8;
      //Color determine
      myList.get(k).colorDetermineXVal(THRESHOLD_INTERMEDIATE_SATM, THRESHOLD_HIGH_SATM);
      
      //Draw points
      ellipse(myScatterPoints.get(k).getXPos(), myScatterPoints.get(k).getYPos(), d, d);
      
      //Debug: text(myList.get(k).toString(),xPos, yPos + 2);
      
    }
  }
  
  String getColumnX(){
      return useColumnX;
  }
  void drawTitle(){
      text (chartName, this.sWidth/2, 10);
  }
  
  void keyPressed() {
    
  }

  void mouseReleased() {
    
  }
 
  void mouseClicked() {
    
    checkPointsForClick(mouseX, mouseY);

  }
  
  void mouseMoved(){
    checkPointsForClick(mouseX, mouseY);
  }

  // Helper method that will check if a scatter point was clicked on  
  public int checkPointsForClick(float _mouseXPos, float _mouseYPos){
    //println("this.sWidth = ,(" + this.sWidth + "," + this.sHeight + ")");
    //if (lastClicked != null) return ;
    //println("mouse pos = ,(" + _mouseXPos + "," + _mouseYPos + ")");
    // Loop over the points to see if one of them is selected
    for (int k=0; k < myScatterPoints.size(); k++) {
      //println("My Point pos = (" + myScatterPoints.get(k).getXPos() + "," + myScatterPoints.get(k).getYPos() + ")");
      //Restores the coordinate system
      //Ref: https://processing.org/tutorials/transform2d/
      if ( abs(myScatterPoints.get(k).distanceTo(_mouseXPos - this.x_pos, _mouseYPos - this.y_pos)) < 8 ) {
         //println("mouseX pos = " + _mouseXPos + "mouseY pos = " + _mouseYPos);
         //println("You hit it! X Point pos = " + myScatterPoints.get(k).getXPos() + "," + myScatterPoints.get(k).getYPos()); 
         //println(myScatterPoints.get(k).toString());
         //text(myScatterPoints.get(k).toString(), _mouseXPos, _mouseYPos - 5);
         //fill(255);
         return 1;
         //showTitle(myScatterPoints.get(k));
      }
      
    } 
    return 0;
  }
  
  // Helper method that will return the scatter point object if it was clicked
  public ScreenPosition returnPointsForClick(ScreenPosition p){
    ScreenPosition myLastClicked = null;
    for (int k=0; k < myScatterPoints.size(); k++) {
      if ( abs(myScatterPoints.get(k).distanceTo(p.getXPos() - this.x_pos, p.getYPos() - this.y_pos)) < 8 ) {
         myLastClicked = myScatterPoints.get(k);
      }   
    }
    return myLastClicked;
  }
  
  // Helper method that will draw the point position description if it was hover/clicked
  public void showTitle(ScreenPosition p)
  {
    String pop = p.toString();
    
    pushStyle();  
    
    fill(255, 0, 0);
    textSize(12);
    rectMode(CORNER);
    //rect(p.getXPos() + this.x_pos , p.getYPos() + this.y_pos, textWidth(pop) + 6, 39);
    fill(0, 0, 0);
    textAlign(LEFT, TOP);
    text(pop, p.getXPos() + this.x_pos + 3, p.getYPos() + this.y_pos -18);   
    popStyle();
  }
  
  public void drawMarker(ScreenPosition p) {
    // Save previous drawing style
    pushStyle();
    
    // IMPLEMENT: drawing triangle for each point
    fill(255, 0, 0);
    
    float xMarkerPos = p.getXPos() + this.x_pos;
    float yMarkerPos = p.getYPos() + this.y_pos;
    triangle(xMarkerPos, yMarkerPos-TRI_SIZE, xMarkerPos-TRI_SIZE, yMarkerPos+TRI_SIZE, xMarkerPos+TRI_SIZE, yMarkerPos+TRI_SIZE);
    
    // Restore previous drawing style
    popStyle();
  }

}
