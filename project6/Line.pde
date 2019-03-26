int buffer = 5;
//float selDist = 5;// radius of the circle
/**
 interactions: click, selection, highlight
 1. switch axes
 **/
 
int binCount = 4;
float scale_unit;

class Line extends Frame {
  String attr0, attr1;
  float [] data0, data1;
  float rmin0, rmax0;
  float rmin1, rmax1;
  //Axes
  Axis[] axes = new Axis[2];
  //PVector selected = null;
  TwoDMarker selectedMarker = null;
  ArrayList<PVector> points = new ArrayList<PVector>();
  ArrayList<TwoDMarker> markers;

  //Constructor
  Line( String _attr0, String _attr1 ) {
    //Allow users to switch axes
    setAttributes( _attr0, _attr1 );

    for ( int i = 0; i < myTable.getRowCount(); i++ ) {
      points.add( new PVector() );
    }

    markers = new ArrayList<TwoDMarker>();

    axes[0] = new Axis(_attr0);
    axes[1] = new Axis(_attr1);
  }
  //End Constructor
  //class method
  void setAttributes( String _attr0, String _attr1 ) {
    attr0 = _attr0;
    attr1 = _attr1;

    data0 = myTable.getFloatColumn(attr0);
    data1 = myTable.getFloatColumn(attr1);

    rmin0 = min(data0);
    rmax0 = max(data0);

    rmin1 = min(data1);
    rmax1 = max(data1);
  }
  //draw the chart
  void draw() {
    
    stroke(0);
    fill(255);
    
    //set position of the axes
    //Horizontal axis
    int u1 = (int)map( rmin0 - buffer, rmin0, rmax0, u0+20, u0+w-20 );
    int u2 = (int)map( rmax0 + buffer, rmin0, rmax0, u0+20, u0+w-20 );

    //Vertical axis
    int v1 = (int)map( rmin1 - buffer, rmin1, rmax1, v0+h-20, v0+20 );
    int v2 = (int)map( rmax1 + buffer, rmin1, rmax1, v0+h-20, v0+20 );
    //println("axes[0] height = 0, width = max - min= " + (u2 - u1));
    
    //highlight the origin 
    fill( 255, 0, 0);
    ellipse( u1, v1, 10, 10 );

    axes[0].setPosition( u1, v1, (u2 - u1), 0);
    axes[1].setPosition( u1, v1, 0, (v2 - v1));

    axes[0].draw();
    
    String axisLabel;
       
       axisLabel = attr0;
       //Border of the textbox
           
       axes[0].drawTextOnScreen( w/2, - 10,
       0, 12, axisLabel);
       
    axes[1].draw();
    
    axisLabel = attr1;
       //Border of the textbox
           
       axes[1].drawTextOnScreen( -10, -h/2,
       0, 12, axisLabel);


    //drawing horizontal tickmarks
    //To do: replace u1, v1 wih axis: xPos, yPos, width and length
    drawAxisValue( binCount, u1, v1, rmin0, rmax0, u0+20, u0+w-20, "horizontal");
    
    //drawing  vertical tickmarks
    drawAxisValue( binCount, u1, v1, rmin1, rmax1, v0+h-20, v0+20, "vertical");
    
    //To do: drawing horizontal gridlines
    
    //update point positions - ArrayList of PVector objects 
    for ( int i = 0; i < points.size(); i++) {
      //Map to the horizontal axis
      float x = map( data0[i], rmin0, rmax0, u0+20, u0+w-20);
      //Map to the vertical axis
      float y = map( data1[i], rmin1, rmax1, v0+h-20, v0+20 );
      points.get(i).set(x, y);

      TwoDPoint tempPoint = new TwoDPoint(data0[i], data1[i]);
      TwoDMarker tempMarker = new TwoDMarker(tempPoint, points.get(i));
      markers.add(tempMarker);
    }
/**    
     println(markers.size());
     
     for (int i=0; i < markers.size(); i++) {
     println("Line chart " + markers.get(i).toString());
     }**/
     
     String title;
       
       title = attr0 + " versus " + attr1;
       //Border of the textbox
       
       //rect( u0, v0, w, h );
       fill(255);
       
       rect(u0, v0, w, 18);
       
           
       this.drawTextOnScreen( (this.w)/2, 18/2,
       0, 12, title);
     
    stroke(0);
    strokeWeight(1); //default
    //draw points with ellipse
    for ( int i = 0; i < markers.size(); i++ ) {
      PVector p = new PVector(markers.get(i).getXPos(), markers.get(i).getYPos());
      fill( 200 );
      ellipse( p.x, p.y, 10, 10 );
    }
    //if the point is selected, pop up an information window
    if ( selectedMarker != null ) {  
      String pop = selectedMarker.toString();
      ellipse( selectedMarker.getXPos(), selectedMarker.getYPos(), 10, 10 );
      textSize(12);
      rectMode(CORNER);
      fill(0, 0, 0);
      textAlign(LEFT, TOP);
      text(pop, selectedMarker.getXPos() + 3, selectedMarker.getYPos() -18);
    }

    //iteration over the HashSet data structure selectedPoints 
    for ( int i : selectedPoints ) {   
      PVector p = points.get(i);
      //visualizae all the selected points with green ellipses  
      fill( 0, 255, 0);//green
      ellipse( p.x, p.y, 10, 10 );
    }

    //draw connecting lines, chỉnh màu
    strokeWeight(1);
    stroke(0);

    int prevIndex = 0;

    for (int k=1; k < myTable.getRowCount(); k++) {
      //Draw line
      line(markers.get(prevIndex).getXPos(), markers.get(prevIndex).getYPos(), markers.get(k).getXPos(), markers.get(k).getYPos());
      prevIndex = k;
    }
   
    //Interaction if the point is selected, pop up the description
    
    //draw the borderline of the scatterplot sketch with black
     stroke(0);
     noFill();
     rect( u0, v0, w, h );
  }


  /***End method void draw()**/
  /**start method mousePressed()**/
  //Debug: make sure comment out the NoLoop method
  void mousePressed() {
    float selDist = 5;// radius of the circle
    for (int i = 0; i < markers.size(); i++) {
      TwoDMarker temp = markers.get(i);
      float d = dist( temp.getXPos(), temp.getYPos(), mouseX, mouseY );
      if ( d < selDist ) {
        selDist = d;
        selectedMarker = temp;
        //add the point's index to the ordered Integer HashSet
        //println("Index inside of Line chart = " + i);
        //if(!selectedPointsLineChart.contains(i)) selectedPointsLineChart.add(i);
        if (!selectedPoints.contains(i)) selectedPoints.add(i);
      }
    }
  }
  /***end method mousePressed***/
  /***end Line class***/
}
void drawAxisValue(int binCount, int xOrigXPos, int yOrigYPos, 
float minVal, float maxVal, 
int startPos, int stopPos, String direction){
    
    int scale_unit = (int)((maxVal - minVal)/binCount);
    
    //draw the tick marks
    for (int i = 0; i <= binCount; i++) {
      //tick mark's y position
      int tickMarkPos;
      //tick mark's actual value
      float tickMark = minVal + i*scale_unit;
      tickMarkPos = (int)map(tickMark, minVal, maxVal, startPos, stopPos);
      //println("tickMark = " + tickMark + " tickMark_yPos = " + xPos);
      String num = String.format ("%,.2f", tickMark);
      if(direction == "horizontal"){
          text (num, tickMarkPos, yOrigYPos + 10);
          line( tickMarkPos, yOrigYPos - 10, tickMarkPos, yOrigYPos + 10);
      }
      else{
          text (num, xOrigXPos - 10, tickMarkPos);
          line( xOrigXPos - 10, tickMarkPos, xOrigXPos + 10, 
          tickMarkPos);
      }
      
    }   
}
//Helper class Marker
// Used by basic charts taught in class for on demand interactions with users
class TwoDMarker {

  TwoDPoint d;
  PVector graphPoint;
  boolean selected = false;

  TwoDMarker() {
  } // default constructor

  TwoDMarker(TwoDPoint _d, PVector _p) {
    d = new TwoDPoint(_d.getXVal(), _d.getYVal());
    graphPoint = new PVector(_p.x, _p.y);
  }
  
  TwoDMarker(TwoDPoint _d, float _x, float _y) {
    d = new TwoDPoint(_d.getXVal(), _d.getYVal());
    graphPoint = new PVector(_x, _y);
  }

  //overriding the toString() method
  public String toString() {  
    return d.toString() + "(" + graphPoint.x + "," + graphPoint.y + ")";
  } 

  float getXPos() {
    return graphPoint.x;
  }
  float getYPos() {
    return graphPoint.y;
  }
  
  TwoDPoint getTwoDPoint(){
    return d;
  }
  

  float distanceTo(TwoDMarker b) {
    return dist(getXPos(), getYPos(), b.getXPos(), b.getYPos());
  }

  void mousePressed() {
    //if an axis is selected, selected = true, mouseInside() function is defined in Frame class 
    selected = true;
  }

  void mouseReleased() {
    selected = false;
  }
}
//End class Marker

//Helper class Axis
// Used by Line chart, Bar chart and Scatterplot taught in class for on demand interactions with users
class Axis extends Frame {
  String attr;
  float [] data;
  float rmin, rmax;
  //flag variable for mouse click interaction
  boolean selected = false;
  

  Axis( String attr ) {
    this.attr = attr;
    data = myTable.getFloatColumn(attr);
    rmin = min(data);
    rmax = max(data);
    
  }


  /*float getU( int idx ){ return u0; }
   
   //get the point's vertical position
   //float getV( int idx ){
   return map( data[idx], rmin, rmax, v0+h-20, v0+20 );
   }*/

  void draw() {
    /** Debug
     println("The horizontal axis's position\n");
     println("The x pos = " + getXPos());
     println("The y pos = " + getYPos());
     println("Width = " + getWidth());
     println("Height = " + getHeight()); **/
    line(u0, v0, u0 + w, v0 + h);
    
    
  }

  void mousePressed() {
    //if an axis is selected, selected = true, mouseInside() function is defined in Frame class 
    //selected = mouseInside();
  }

  void mouseReleased() {
    //selected = false;
  }
}
//End Helper class Axis
