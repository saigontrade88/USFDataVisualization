
class Scatterplot extends Frame{
  
  String attr0, attr1;
  float [] data0, data1;
  float rmin0, rmax0;
  float rmin1, rmax1;
  
  PVector selected = null;
  ArrayList<PVector> points = new ArrayList<PVector>();
  
  Scatterplot( String _attr0, String _attr1 ){
    setAttributes( _attr0, _attr1 );
    
    for( int i = 0; i < myTable.getRowCount(); i++ ){
      points.add( new PVector() );
    }
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
  
  int buffer = 5;
  
  void draw(){
    //update point positions
   for( int i = 0; i < points.size(); i++){
     float x = map( data0[i], rmin0,rmax0, u0+buffer,u0+w-buffer );
     float y = map( data1[i], rmin1,rmax1, v0+h-buffer,v0+buffer );
     points.get(i).set(x,y);
   }
   
   // draw points
   
   /*Sets the color used to draw lines and borders around shapes. 
    This color is either specified in terms of the RGB or HSB color depending on the current colorMode(). 
   */
   stroke(0);
   strokeWeight(1); //default
   //for( PVector p : points ){
   for( int i = 0; i < points.size(); i++ ){
     PVector p = points.get(i);
     fill( 200 );
     if( selectedPoints.contains(i) ) fill( 0,255,0);
     ellipse( p.x, p.y, 10,10 ); 
   }
   
   //iteration over the HashSet data structure selectedPoints 
   for( int i : selectedPoints ){
     PVector p = points.get(i);
     //visualizae all the selected points with green ellipses  
     fill( 0,255,0);
     ellipse( p.x, p.y, 10,10 ); 
   }
   //if the point is selected, visualize it with red ellipse
   if( selected != null ){
     fill( 255,0,0);
     ellipse( selected.x, selected.y, 10,10 ); 
     
   }
   //draw the borderline of the scatterplot sketch with black
   stroke(0);
   noFill();
   rect( u0, v0, w, h );
   
  }
  
  
  void mousePressed(){
    float selDist = 5;
    for( int i = 0; i < points.size(); i++ ){
      PVector p = points.get(i);
      float d = dist( p.x,p.y, mouseX, mouseY );
      if( d < selDist ){
         selDist = d;
         selected = p;
         //add the point's index to the ordered Integer HashSet
         println("Index inside of Scatterplot = " + i);
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
  
  
}
