


class PCP extends Frame {
  
    ArrayList<PCPAxis> axes = new ArrayList<PCPAxis>( );
    int border = 20;
    
   PCP( ){
     for( int i = 0; i < myTable.getColumnCount(); i++ ){
       axes.add( new PCPAxis( myTable.getColumnTitle(i) ) );
     }
   }

   void updatePositions(){
     
   }
   
   
   void draw() {
     //set position for each axis
     for( int i = 0; i < axes.size(); i++ ){
       //u: horizontal position, 20 is the buffer
       int u = (int)map( i, 0, axes.size()-1, u0+20, u0+w-20 );
       //h: height of the sketch as defined in the main sketch
       axes.get(i).setPosition( u, v0, 10, h ); 
     }      
     
     //draw the axes
     for( int i = 0; i < axes.size(); i++ ){
        axes.get(i).draw();
     }

      strokeWeight(1);
      stroke(0);
      //draw the lines
      for( int i = 0; i < myTable.getRowCount(); i++ ){   
         float u0 = axes.get(0).getU(i);
         float v0 = axes.get(0).getV(i);
         for( int j = 1; j < axes.size(); j++ ){
            //determine the x,y position of the current point
            float u1 = axes.get(j).getU(i);
            float v1 = axes.get(j).getV(i);
            line( u0, v0, u1, v1 );
            //update the x,y position of the previous point
            u0 = u1;
            v0 = v1;
         }
      }
   }
   

  void mousePressed(){ 
    for( PCPAxis a : axes ){
      a.mousePressed();
    }
    // implement brushing
  }
  
  void mouseReleased(){ 
    for( PCPAxis a : axes ){
      a.mouseReleased();
    }
  }
  
}


class PCPAxis extends Frame {
  String attr;
  float [] data;
  float rmin, rmax;
  //flag variable for mouse click interaction
  boolean selected = false;
  
  PCPAxis( String attr ){
    this.attr = attr;
    data = myTable.getFloatColumn(attr);
    rmin = min(data);
    rmax = max(data);
  }
  
  
  float getU( int idx ){ return u0; }
  
  //get the point's vertical position
  float getV( int idx ){
    return map( data[idx], rmin, rmax, v0+h-20, v0+20 );
  }
  
  void draw(){
    if( selected ){
       //drag and drop the axis
       u0 = mouseX; 
    }

    strokeWeight(5);
    stroke(0);
    //if the axis is selected then paint it with red
    if( selected ) stroke( 255,0,0);
    line(u0,v0,u0,v0+h);
    
  }
  
  void mousePressed() {
      //if an axis is selected, selected = true, mouseInside() function is defined in Frame class 
      selected = mouseInside();
  }
  
  void mouseReleased() {
      selected = false;
  }
  
  
}
