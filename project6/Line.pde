int buffer = 5;
float selDist = 5;// radius of the circle
/**
 interactions: click, selection, highlight
 1. switch axes
 **/

class Line extends Frame {
  String attr0, attr1;
  float [] data0, data1;
  float rmin0, rmax0;
  float rmin1, rmax1;
  //Axes
  Axis[] axes = new Axis[2];
  //PVector selected = null;
  TwoDMarker selected = null;
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
    //Draw the borderline of the linechart
    stroke(0);
    noFill();
    rect( u0, v0, w, h );
    
    //set position of the axes
    //Horizontal axis
    int u1 = (int)map( rmin0 - buffer, rmin0, rmax0, u0+20, u0+w-20 );
    int u2 = (int)map( rmax0 + buffer, rmin0, rmax0, u0+20, u0+w-20 );
    
    //Vertical axis
    int v1 = (int)map( rmin1 - buffer, rmin1, rmax1, v0+h-20, v0+20 );
    int v2 = (int)map( rmax1 + buffer, rmin1, rmax1, v0+h-20, v0+20 );
    //println("max - min= " + (u2 - u1));
    
    fill( 255, 0, 0);
    ellipse( u1, v1 , 10, 10 );
   
    axes[0].setPosition( u1, v1, (u2 - u1), 0);
    axes[1].setPosition( u1, v1, 0, (v2 - v1));
    
    axes[0].draw();
    axes[1].draw();
    
    //To do: drawing tickmarks
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
   /* Debug  
    println(markers.size());
     
     for (int i=0; i < markers.size(); i++) {
     println(markers.get(i).toString());
     }
   */

    
    stroke(0);
    strokeWeight(1); //default
    //draw points with ellipse
    for ( int i = 0; i < markers.size(); i++ ) {
      PVector p = new PVector(markers.get(i).getXPos(), markers.get(i).getYPos());
      fill( 200 );
      //if( selectedPoints.contains(i) ) fill( 0,255,0);
      ellipse( p.x, p.y, 10, 10 );
    }

    //draw connecting lines, chỉnh màu
    strokeWeight(1);
    stroke(0);

    int prevIndex = 0;
    /**
    for (int k=1; k < markers.size(); k++) {

      println("(" + prevIndex + "," + k + ")");

      //float x0 = markers.get(0).getXPos();
      //float y0 = markers.get(0).getYPos();
      //Color determine
      //myList.get(k).colorDetermineXVal(THRESHOLD_INTERMEDIATE_SATM, THRESHOLD_HIGH_SATM);

      //Draw line
      line(markers.get(prevIndex).getXPos(), markers.get(prevIndex).getYPos(), markers.get(k).getXPos(), markers.get(k).getYPos());

      prevIndex = k;
      //Debug: text(myList.get(k).toString(),xPos, yPos + 2);
    }*/
    /**
    for (int k=0; k < markers.size(); k++) {
        float x0 = markers.get(0).getXPos();
        float y0 = markers.get(0).getYPos();
        
        for (int j=1; j < markers.size(); j++){
            float x1 = markers.get(j).getXPos();
            float y1 = markers.get(j).getYPos();
            
            line( x0, y0, x1, y1 );
            //update the x,y position of the previous point
            x0 = x1;
            y0 = y1;
        }
    }**/
    
    //Interaction if the point is selected, pop up the description
    if ( selected != null ) {  
      String pop = selected.toString();
      fill( 255, 0, 0);
      ellipse( selected.getXPos(), selected.getYPos(), 10, 10 );
      textSize(12);
      rectMode(CORNER);
      //rect(p.getXPos() + this.x_pos , p.getYPos() + this.y_pos, textWidth(pop) + 6, 39);
      fill(0, 0, 0);
      textAlign(LEFT, TOP);
      text(pop, selected.getXPos() + 3, selected.getYPos() -18);
      //selected.draw();
    }
  }

 
  /***End method void draw()**/
  /**start method mousePressed()**/
  //Debug: make sure comment out the NoLoop method
  void mousePressed() {
    for ( TwoDMarker p : markers ) {
      float d = dist( p.getXPos(), p.getYPos(), mouseX, mouseY );
      if ( d < selDist ) {
        //selDist = d;
        selected = p;
      }
    }
  }

  /***end method mousePressed***/
  /***end Line class***/
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

  //overriding the toString() method
  public String toString() {  
    return d.toString() + " (" + graphPoint.x + "," + graphPoint.y + ")";
  } 

  float getXPos() {
    return graphPoint.x;
  }
  float getYPos() {
    return graphPoint.y;
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
  
  Axis( String attr ){
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
  
  void draw(){
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
