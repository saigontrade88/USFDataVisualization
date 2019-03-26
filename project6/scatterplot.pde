
class Scatterplot extends Frame{
  
  String attr0, attr1;
  float [] data0, data1;
  float rmin0, rmax0;
  float rmin1, rmax1;
  
  //Axes
  Axis[] axes = new Axis[2];
  //used to interaction: clicked and show description
  TwoDMarker selectedMarker = null;
  
  PVector selected = null;
  
  ArrayList<PVector> points = new ArrayList<PVector>();
  
  //list of data points can be used to replace ArrayList points
  ArrayList<TwoDMarker> markers;
  
  //Constructor
  Scatterplot( String _attr0, String _attr1 ){
    setAttributes( _attr0, _attr1 );
    
    for( int i = 0; i < myTable.getRowCount(); i++ ){
      points.add( new PVector() );
    }
    
    markers = new ArrayList<TwoDMarker>();
    
    axes[0] = new Axis(_attr0);
    axes[1] = new Axis(_attr1);
  }
  
  void setAttributes( String _attr0, String _attr1 ){
    attr0 = _attr0;
    attr1 = _attr1;
    
    data0 = myTable.getFloatColumn(attr0);
    data1 = myTable.getFloatColumn(attr1);
    
    rmin0 = min(data0);
    rmax0 = max(data0);
    
    rmin1 = min(data1);
    rmax1 = max(data1);
  }
  
  int buffer = 20;
  
  void draw(){
    
    stroke(0);
    fill(255);
   
   //update point positions
   
   //textAlign(CENTER);
   
   textSize(8);
   
   fill(0);
   
   text (attr0, u0 + w/2, v0 + h - 5);
   
   text (attr1, u0 + 5, v0 + h/2);
   
   //draw horizontal axis
    int u1 = (int)map( rmin0, rmin0, rmax0, u0+buffer,u0+w-buffer);
    int u2 = (int)map( rmax0, rmin0, rmax0, u0+buffer,u0+w-buffer );

    //Vertical axis
    int v1 = (int)map( rmin1, rmin1, rmax1, v0+h-buffer,v0+buffer );
    int v2 = (int)map( rmax1, rmin1, rmax1, v0+h-buffer,v0+buffer );
    //println("axes[0] height = 0, width = max - min= " + (u2 - u1));
    
    //highlight the origin 
    fill( 255, 0, 0);
    ellipse( u1 - buffer/2, v1 + buffer/2, 10, 10 );

    axes[0].setPosition( u1 - buffer/2, v1 + buffer/2, (u2 - u1) + buffer, 0);
    axes[1].setPosition( u1 - buffer/2, v1 + buffer/2, 0, (v2 - v1) - buffer);
    
    axes[0].draw();
    axes[1].draw();
    
    //drawing horizontal tickmarks
    //To do: replace u1, v1 wih axis: xPos, yPos, width and length
    drawAxisValue( binCount, u1 - buffer/2, v1 + buffer/2, rmin0, rmax0, u0+buffer, u0+w-buffer, "horizontal");
    
    //drawing  vertical tickmarks
    drawAxisValue( binCount, u1 - buffer/2, v1 + buffer/2, rmin1, rmax1, v0+h-buffer, v0+buffer, "vertical");
    
   //read data   
   for( int i = 0; i < points.size(); i++){
     float x = map( data0[i], rmin0,rmax0, u0+buffer,u0+w-buffer );
     float y = map( data1[i], rmin1,rmax1, v0+h-buffer,v0+buffer );
     points.get(i).set(x,y);
     
     
     TwoDPoint tempPoint = new TwoDPoint(data0[i], data1[i]);
     TwoDMarker tempMarker = new TwoDMarker(tempPoint, points.get(i));
     markers.add(tempMarker);
   }
   
   // draw points
   
   /*Sets the color used to draw lines and borders around shapes. 
    This color is either specified in terms of the RGB or HSB color depending on the current colorMode(). 
   */
   stroke(0);
   strokeWeight(1); //default
   //for( PVector p : points ){
   for( int i = 0; i < markers.size(); i++ ){
     TwoDMarker p = markers.get(i);
     TwoDPoint temp = new TwoDPoint(markers.get(i).getTwoDPoint());
     //fill( 200 );
     if( selectedPoints.contains(i) ) fill( 0,255,0);
     ellipse( p.getXPos(), p.getYPos(), 10,10 ); 
     //temp.colorDetermineXVal(THRESHOLD_INTERMEDIATE_SATM, 
     //THRESHOLD_HIGH_SATM,
     //THRESHOLD_INTERMEDIATE_SATV,
     //THRESHOLD_HIGH_SATV);
     
   }
   //interaction: if the point is selected, pop up an information window
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
   for( int i : selectedPoints ){
     PVector p = points.get(i);
     //visualizae all the selected points with green ellipses  
     fill( 0,255,0);
     ellipse( p.x, p.y, 10,10 ); 
   }
   //interaction: if the point is selected, visualize it with a star shape
   //Furthermore, draw the cross lines 
   
   if( selectedMarker != null ){
     
     fill( 248, 151, 29);
     
     //void star(float x, float y, float radius1, float radius2, int npoints)    
     star(selectedMarker.getXPos(), selectedMarker.getYPos(), 5, 11, 5); 
     //draw the horizontal lines
     
     stroke(248, 151, 29);
     line(selectedMarker.getXPos(), selectedMarker.getYPos(),
          u0+w-buffer , selectedMarker.getYPos());
     
     line(selectedMarker.getXPos(), selectedMarker.getYPos(),
          axes[1].getXPos() , selectedMarker.getYPos());
     
     //draw the vertical lines    
     line(selectedMarker.getXPos(), selectedMarker.getYPos(),
      selectedMarker.getXPos(), v0+buffer);
      
      line(selectedMarker.getXPos(), selectedMarker.getYPos(),
      selectedMarker.getXPos(), v1 + buffer/2);
     
   }
   
   
   
   //draw the borderline of the scatterplot sketch with black
   stroke(0);
   noFill();
   rect( u0, v0, w, h );
   
  }
  
  
  void mousePressed(){
    float selDist = 10;
    for( int i = 0; i < markers.size(); i++ ){
      TwoDMarker temp = markers.get(i);
      float d = dist( temp.getXPos(), temp.getYPos(), mouseX, mouseY );
      if( d < selDist ){
         selDist = d;
         selectedMarker = temp;
        
         
         //add the point's index to the ordered Integer HashSet
         //println("Index inside of Scatterplot = " + i);
         if(!selectedPoints.contains(i)) selectedPoints.add(i);
      }
    }    
    /*
    for( PVector p : points ){
      float d = dist( p.x,p.y, mouseX, mouseY );
      if( d < selDist ){
         selDist = d;
         selected = p;
      }
    }
    */
    
  }
  //End mouse click
  void mouseMoved(){  }
  
  
  
}
//Source: https://processing.org/examples/star.html
void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
