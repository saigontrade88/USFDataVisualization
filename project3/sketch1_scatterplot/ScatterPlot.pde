import java.util.ArrayList;

float []myArrayBuffer = {69.5, 60, 1.05, 0.38}; // 1 standard deviation

//float myYBuffer = 60;



class ScatterPlot extends Frame {

  Table data;// Table contains x-data, y-data
  String useColumnX, useColumnY, chartName;
  int x_pos, y_pos; // Refer to the top left corner of the scatter plot
  int sWidth; // Scatterplot chart is a rectangular canvas with the corresponding width and height 
  int sHeight; 
  ArrayList<PointEntry> myList;   // to store x-,y- data from raw data
  ArrayList<ScreenPosition> myScatterPoints; 

  ScatterPlot( Table _data, String _useColumnX, String _useColumnY, String _chartName, int _xPos, int _yPos, int _sWidth, int _sHeight) {
    data = _data;
    useColumnX = _useColumnX;
    useColumnY = _useColumnY;
    chartName = _chartName;
    x_pos  = _xPos;
    y_pos  = _yPos;
    sWidth = _sWidth;
    sHeight = _sHeight;
    myList = new ArrayList<PointEntry>();
    println("row count: "+_data.getRowCount());
    myScatterPoints = new ArrayList<ScreenPosition>();
    createList(); //<>//
  }

  
   void draw() {  

    //(0,0) - the origin point
    translate(x_pos, y_pos);

    //fill(255);

    //rect(0,0,sWidth, sHeight);
    
    fill(0);
    
    drawTitle();
    
    drawYAxis(this.useColumnY, 0.0f);

    drawXAxis(this.useColumnX, 0.0f);

    drawPoints(this.useColumnX, this.useColumnY, 0.0f, 0.0f);

  } 
  
  void createList()
  { 
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

  float findMaxValue(String _useColumn) {
   // if ( (_useColumn != useColumnX) &&  (_useColumn != useColumnY))
   //   return -1000.0f;

    PointEntry maxPointEntry = myList.get(0);

    float maxValue = maxPointEntry.getXVal();

    for (int k=1; k < myList.size(); k++) {
      if (maxValue < myList.get(k).getXVal())
        maxValue = myList.get(k).getXVal();
    }

    if (_useColumn == useColumnY) {
      maxValue  = maxPointEntry.getYVal();

      for (int k=1; k < myList.size(); k++) {
        if (maxValue < myList.get(k).getYVal())
          maxValue = myList.get(k).getYVal();
        // process s
      }
    }
    return maxValue;
  }
  float findMinValue(String _useColumn) {
    //if ( (_useColumn != useColumnX) &&  (_useColumn != useColumnY))
    //  return 1000.0f;

    PointEntry minPointEntry = myList.get(0);

    float minValue = minPointEntry.getXVal();

    for (int k=1; k < myList.size(); k++) {
      if (minValue > myList.get(k).getXVal())
        minValue = myList.get(k).getXVal();
    }

    if (_useColumn == useColumnY) {
      minValue  = minPointEntry.getYVal();

      for (int k=1; k < myList.size(); k++) {
        if (minValue > myList.get(k).getYVal())
          minValue = myList.get(k).getYVal();
        // process s
      }
    }
    return minValue;
  }  

  void drawYAxis(String _useColumnY, Float myBuffer) {
    
    // Used to find the scale unit; 
    int binCount = 5;
    // 10% is allocated for label
    float factor = 0.1; 

    //Factor used to draw the tick marks
    float deltaC = 1.2;

    // The maximum value of the selected data range    
    float maxValue = findMaxValue(_useColumnY);

    float minValue = findMinValue(_useColumnY);
    
    float scale_unit = (maxValue - minValue)/binCount;

    // Scaled min and max values    
    float maxValue_yPos = map(maxValue, minValue - myBuffer, maxValue + myBuffer, this.sHeight - 20, 10);
    
    float minValue_yPos = map(minValue, minValue - myBuffer, maxValue + myBuffer, this.sHeight - 20, 10);
    
   // println("Drawing y scale: maxValue = " + maxValue + " maxValue_yPos = " + maxValue_yPos);
   // println("Drawing y scale: minValue = " + minValue + " minValue_yPos = " + minValue_yPos);
    //y Axis position of tick marks;
    float yPos;

    // Line and labels for Y axis
    textAlign(RIGHT);

   // fill(0, 255, 0);
    // Draw the vertical line
    line(10, 10, 10, this.sHeight - 20);
    
   //println(this.x_pos + "," + this.y_pos+ "," + this.x_pos+ "," + maxValue_yPos);
  //println(int(minValue - myBuffer));
  //println(int(maxValue + myBuffer) + 1);
  
  
  float tickMark;
    // Draw the values and the corresponding tick marks
    for (int i = 0;i <= binCount; i++) {
      tickMark = minValue + i*scale_unit;
      println(tickMark);
      yPos = map(tickMark, minValue - myBuffer, maxValue + myBuffer, this.sHeight -20, 10);
      println("tickMark = " + tickMark + " tickMark_yPos = " + yPos);
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

    // The maximum value of the selected data range    
    float maxValue = findMaxValue(_useColumnX);

    float minValue = findMinValue(_useColumnX);
    
    float scale_unit = (maxValue - minValue)/binCount;

    //println(maxValue);

    // Scaled min and max values    
    float maxValue_xPos = map(maxValue, minValue - myBuffer, maxValue + myBuffer, 10, this.sWidth);

    float minValue_xPos = map(minValue, minValue - myBuffer, maxValue + myBuffer, 10, this.sWidth);

    //y Axis position of tick marks;
    float xPos;

    // Line and labels for Y axis
    textAlign(CENTER);

    // Draw the horizontal line
    line(10, this.sHeight - 20, this.sWidth, this.sHeight - 20);

    //println(this.x_pos + "," + this.y_pos+ "," + maxValue_xPos + "," + this.y_pos);
     float tickMark;
    // Draw the values and the corresponding tick marks
     for (int i = 0;i <= binCount; i++) {
      tickMark = minValue + i*scale_unit;
      xPos = map(tickMark, minValue - myBuffer, maxValue + myBuffer, 10, this.sWidth);
      //println("tickMark_yPos = " + yPos);
      
       String num = String.format ("%,.2f",tickMark); 
      
      text (num, xPos, this.sHeight);

      line(xPos, this.sHeight - 20 - deltaC, xPos, this.sHeight - 20 + deltaC);
    }

    // Draw the label according to the min and max values's y positions
    text(_useColumnX, sWidth, this.sHeight - 25);
  }

  void drawPoints(String _useColumnX, String _useColumnY, Float _myXBuffer, Float _myYBuffer) {

    for (int k=0; k < myList.size(); k++) {

      float xPos;

      float yPos;

      //map(maxValue, minValue - myBuffer, maxValue + myBuffer, 0, this.sWidth);
      xPos = map(myList.get(k).getXVal(), findMinValue(_useColumnX) - _myXBuffer, findMaxValue(_useColumnX)+ _myXBuffer, 10, this.sWidth);

      // map(maxValue, minValue - myBuffer, maxValue + myBuffer, this.sHeight , 0);
      yPos = map(myList.get(k).getYVal(), findMinValue(_useColumnY) - _myYBuffer, findMaxValue(_useColumnY) + _myYBuffer, this.sHeight -20, 10);

      stroke(palette[1]);
      // line(x, y, x, 150);
      //   noStroke();
      //println( myList.get(k).toString() );

      //   println( "The scaled point is at" + "(" + xPos + "," + yPos + ")");

      ScreenPosition temp = new ScreenPosition(myList.get(k), xPos, yPos);

      //println(temp.toString());

      this.myScatterPoints.add(temp);

      fill(palette[1]);

      int d = 8;
      //Color determine
      myList.get(k).colorDetermineXVal(THRESHOLD_INTERMEDIATE_SATM, THRESHOLD_HIGH_SATM);
      
      //Draw points
      ellipse(xPos, yPos, d, d);
      
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
  
}
