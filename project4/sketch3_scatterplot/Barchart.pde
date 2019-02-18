import java.util.ArrayList;

//float myYBuffer = 60;

class Barchart extends Frame {

  Table data;// Table contains x-data, y-data
  String useColumn, chartName;
  int x_pos, y_pos; // Refer to the top left corner of the line chart
  int sWidth; // Scatterplot chart is a rectangular canvas with the corresponding width and height 
  int sHeight; 
  //Build the scale
  float  myMinValue;
  float  myMaxValue;
  //float[]  myYValueArray;
  ArrayList<PointEntry> myList; // to store x-,y- data from raw data
  ArrayList<ScreenPosition> myPoints; 
  boolean clicked;
  //boolean selected;

  Barchart( Table _data, String _useColumn, String _chartName, int _xPos, int _yPos, int _sWidth, int _sHeight) {
    data = _data;
    useColumn = _useColumn;
    chartName = _chartName;

    x_pos  = _xPos;
    y_pos  = _yPos;

    sWidth = _sWidth;
    sHeight = _sHeight;

    clicked = false;

    //selected = false;

    myMinValue = findMinValue(_data.getFloatColumn(_useColumn));
    myMaxValue = findMaxValue(_data.getFloatColumn(_useColumn));

    //println("row count: "+_data.getRowCount());

    //println("min X: "+ myMin_XValue);
    //println("max X: "+ myMax_XValue);
    //println("min Y: "+ myMin_YValue);
    //println("max Y: "+ myMax_YValue);

    myList = new ArrayList<PointEntry>();

    createList();

    //println("My original size list is = " + myList.size());

    myPoints = new ArrayList<ScreenPosition>();

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
    if (clicked == true) {

      //println("Draw the scatterplot");
      pushMatrix();

      //(0,0) - the origin point
      translate(x_pos, y_pos);

      fill(255);

      //rect(0,0,sWidth, sHeight);

      fill(0);

      drawTitle();

      drawYAxis(this.useColumn, 0.0f);

      drawXAxis(this.useColumn, 0.0f);

      drawBar(this.useColumn, this.useColumn, 0.0f, 0.0f);

      popMatrix();
    }
  } 

  /*
  * Create a list containing (x actual value, y actual value)
   */

  void createList() { 
    int xIndex = this.data.getColumnIndex(useColumn);
    for (TableRow row : data.rows())
    {
      float quantVar1 = row.getFloat(xIndex);
      float quantVar2 = 0.0f;
      myList.add(new PointEntry(quantVar2, quantVar1));
    }
    print(myList.size());

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
   * Create a list containing the screen positions
   *
   * @param:
   * @return the array list
   */

  void createMap() {

    for (int k=0; k < myList.size(); k++) {

      float xPos;

      float yPos;

      float _myXBuffer = 0.0;

      float _myYBuffer = 0.0;

      // use map function to scale the input data values

      xPos = map(k, 0, myList.size() - 1 + _myXBuffer, 10, this.sWidth);

      yPos = map(myList.get(k).getYVal(), myMinValue - _myYBuffer, myMaxValue + _myYBuffer, this.sHeight -20, 10);

      ScreenPosition temp = new ScreenPosition(myList.get(k), xPos, yPos);

      this.myPoints.add(temp);

      println(myPoints.size());
    }
  }

  void drawYAxis(String _useColumnY, Float myBuffer) {

    // Used to find the scale unit; 
    int binCount = 5;
    // 10% is allocated for label
    float factor = 0.1; 

    //Factor used to draw the tick marks
    float deltaC = 1.2;

    float scale_unit = (myMaxValue - myMinValue)/binCount;

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
    for (int i = 0; i <= binCount; i++) {
      //tick mark's y position
      float yPos;
      //tick mark's actual value
      tickMark = myMinValue + i*scale_unit;
      //println(tickMark);
      yPos = map(tickMark, myMinValue - myBuffer, myMaxValue + myBuffer, this.sHeight -20, 10);
      //println("tickMark = " + tickMark + " tickMark_yPos = " + yPos);
      String num = String.format ("%,.2f", tickMark); 
      text (num, 0, yPos);
      line( 10-deltaC, yPos, 10+deltaC, yPos);
    }

    // Draw the label according to the min and max values's y positions
    text(_useColumnY, 35, 5);
  }

  void drawXAxis(String _useColumnX, Float myBuffer) {

    // Used to find the scale unit; 
    int binCount = myList.size();
    //Factor used to draw the tick marks
    float deltaC = 1.5;

    float scale_unit = (this.sWidth - 10)/binCount;

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
    for (int i = 0; i < myPoints.size(); i++) {
      //tick mark's x position 
      float xPos;
      //tick mark's actual values
      //tickMark = myMinValue + i*scale_unit;

      //xPos = map(k, 0, myList.size() - 1 + _myXBuffer, 10, this.sWidth);
      xPos = myPoints.get(i).getXPos();
      //println("tickMark_yPos = " + yPos);

      //String num = String.format ("%,.2f",tickMark); 

      //text (num, xPos, this.sHeight);

      line(xPos, this.sHeight - 20 - deltaC, xPos, this.sHeight - 20 + deltaC);
    }

    // Draw the label according to the min and max values's y positions
    text(_useColumnX, sWidth, this.sHeight - 25);
  }

  void drawBar(String _useColumnX, String _useColumnY, float _myXBuffer, float _myYBuffer) {
    
    float  myMinValue_xPos = map(0, 0, myList.size() - 1 + _myXBuffer, 10, this.sWidth);

    float  myMaxValue_xPos = map(myList.size() - 1 + _myXBuffer, 0, myList.size() - 1 + _myXBuffer, 10, this.sWidth);

    float myMinValue_yPos = map(myMinValue, myMinValue - _myYBuffer, myMaxValue + _myYBuffer, this.sHeight -20, 10);

    float rectWidth = (myMaxValue_xPos - myMinValue_xPos) / myList.size();

    for (int k=0; k < myPoints.size(); k++) {

      int d = 8;
      //Color determine
      //myList.get(k).colorDetermineXVal(THRESHOLD_INTERMEDIATE_SATM, THRESHOLD_HIGH_SATM);

      //Draw bar
      ellipse(myPoints.get(k).getXPos(), myPoints.get(k).getYPos(), d, d);

      fill(255, 0, 0);

      rect(myPoints.get(k).getXPos(), myPoints.get(k).getYPos(), rectWidth, myMinValue_yPos - myPoints.get(k).getYPos());
      //myMinValue_yPos - myPoints.get(k).getYPos()
      //Debug: text(myList.get(k).toString(),xPos, yPos + 2);
    }
  }

  String getColumnX() {
    return useColumn;
  }

  void setColumn( String _useColumn ) {
    useColumn = _useColumn;
  }

  void drawTitle() {
    text (chartName, this.sWidth/2, 10);
  }

  void keyPressed() {
  }

  void mouseReleased() {
  }

  void mouseClicked() {

    checkPointsForClick(mouseX, mouseY);
  }

  void mouseMoved() {
    checkPointsForClick(mouseX, mouseY);
  }

  // Helper method that will check if a bar chart was clicked on  
  public int checkPointsForClick(float _mouseXPos, float _mouseYPos) {
    
    float _myXBuffer = 0.0f;
    
    float _myYBuffer = 0.0f;
    
    float  myMinValue_xPos = map(0, 0, myList.size() - 1 + _myXBuffer, 10, this.sWidth);

    float  myMaxValue_xPos = map(myList.size() - 1 + _myXBuffer, 0, myList.size() - 1 + _myXBuffer, 10, this.sWidth);

    float myMinValue_yPos = map(myMinValue, myMinValue - _myYBuffer, myMaxValue + _myYBuffer, this.sHeight -20, 10);

    float rectWidth = (myMaxValue_xPos - myMinValue_xPos) / myList.size();
    
    //println("this.sWidth = ,(" + this.sWidth + "," + this.sHeight + ")");
    //if (lastClicked != null) return ;
    //println("mouse pos = ,(" + _mouseXPos + "," + _mouseYPos + ")");
    // Loop over the points to see if one of them is selected
    for (int k=0; k < myPoints.size(); k++) {
      //println("My Point pos = (" + myScatterPoints.get(k).getXPos() + "," + myScatterPoints.get(k).getYPos() + ")");
      //Restores the coordinate system
      //Ref: https://processing.org/tutorials/transform2d/
      float myMouseXPos = _mouseXPos - this.x_pos;
      float myMouseYPos = _mouseYPos - this.y_pos;
      
      //rect(myPoints.get(k).getXPos(), myPoints.get(k).getYPos(), rectWidth, myMinValue_yPos - myPoints.get(k).getYPos());
      if ( myMouseXPos >= myPoints.get(k).getXPos() && myMouseXPos < myPoints.get(k).getXPos() + rectWidth){
        //println("mouseX pos = " + _mouseXPos + "mouseY pos = " + _mouseYPos);
        //println("You hit it! X Point pos = " + myPoints.get(k).getXPos() + "," + myPoints.get(k).getYPos()); 
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
  public ScreenPosition returnPointsForClick(ScreenPosition p) {
    
    ScreenPosition myLastClicked = null;
    
    float _myXBuffer = 0.0f;
    
    float _myYBuffer = 0.0f;
    
    float  myMinValue_xPos = map(0, 0, myList.size() - 1 + _myXBuffer, 10, this.sWidth);

    float  myMaxValue_xPos = map(myList.size() - 1 + _myXBuffer, 0, myList.size() - 1 + _myXBuffer, 10, this.sWidth);

    float myMinValue_yPos = map(myMinValue, myMinValue - _myYBuffer, myMaxValue + _myYBuffer, this.sHeight -20, 10);

    float rectWidth = (myMaxValue_xPos - myMinValue_xPos) / myList.size();
    for (int k=0; k < myPoints.size(); k++) {
      if ( p.getXPos() - this.x_pos >= myPoints.get(k).getXPos() && p.getXPos() - this.x_pos < myPoints.get(k).getXPos() + rectWidth){
        myLastClicked = myPoints.get(k);
      }
    }
    return myLastClicked;
  }

  // Helper method that will draw the point position description if it was hover/clicked
  public void showTitle(ScreenPosition p)
  { 
    if(p != null){
        
        String pop = p.toString(); //<>//
    
        pushStyle();  
    
        fill(255, 0, 0);
        textSize(12);
        rectMode(CORNER);
        //rect(p.getXPos() + this.x_pos , p.getYPos() + this.y_pos, textWidth(pop) + 6, 39);
        fill(0, 0, 0);
        textAlign(LEFT, TOP);
        text(pop, p.getXPos() + this.x_pos, p.getYPos() + this.y_pos);   
        popStyle();
    }
  }

  public void drawMarker(ScreenPosition p) {
    // Save previous drawing style
    if(p != null){
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
}
