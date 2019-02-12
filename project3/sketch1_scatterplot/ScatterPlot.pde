import java.util.ArrayList;

float []myArrayBuffer = {69.5, 60, 1.05, 0.38}; // 1 standard deviation

//float myYBuffer = 60;



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

  ScatterPlot( Table _data, String _useColumnX, String _useColumnY, String _chartName, int _xPos, int _yPos, int _sWidth, int _sHeight) {
    data = _data;
    useColumnX = _useColumnX;
    useColumnY = _useColumnY;
    chartName = _chartName;
    
    x_pos  = _xPos;
    y_pos  = _yPos;
    
    sWidth = _sWidth;
    sHeight = _sHeight;
    
    myMin_XValue = findMinValue(_data.getFloatColumn(_useColumnX));
    myMax_XValue = findMaxValue(_data.getFloatColumn(_useColumnX));
    myMin_YValue = findMinValue(_data.getFloatColumn(_useColumnY));
    myMax_YValue = findMaxValue(_data.getFloatColumn(_useColumnY));
      
    println("row count: "+_data.getRowCount());
    
    println("min X: "+ myMin_XValue);
    println("max X: "+ myMax_XValue);
    println("min Y: "+ myMin_YValue);
    println("max Y: "+ myMax_YValue);
    
    myList = new ArrayList<PointEntry>();
    
    createList(); //<>//
    
    myScatterPoints = new ArrayList<ScreenPosition>();
    
    createMap();
  }

  
   void draw() { 
     
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
  * Create a list containing the screen positions
  *
  * @param:
  * 
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
      println(tickMark);
      yPos = map(tickMark, myMin_YValue - myBuffer, myMax_YValue + myBuffer, this.sHeight -20, 10);
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
 
  void mousePressed() {
    for (int k=0; k < myScatterPoints.size(); k++) {
      if((dist(myScatterPoints.get(k).getXPos(), myScatterPoints.get(k).getYPos(), mouseX, mouseY) < 20) && mousePressed)
          rect(mouseX, mouseY, 10, 10);
    }
  }
}
