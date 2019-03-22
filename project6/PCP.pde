


class PCP extends Frame {
  
    ArrayList<PCPAxis> axes = new ArrayList<PCPAxis>( );
    int border = 20;
    
   PCP( ){
     for( int i = 0; i < myTable.getColumnCount(); i++ ){
       axes.add( new PCPAxis( myTable.getColumnTitle(i) ) );
     }
   }

   void updatePositions(){
     //new Comparator class - sort the array list based on the horizontal position
     axes.sort(new Comparator<PCPAxis>(){
         public int compare( PCPAxis a0, PCPAxis a1){
           if(a0.u0 < a1.u0) return -1;
           if(a0.u0 > a1.u0) return 1;
           return 0;
         }
     });
     //Reset the position
     for( int i = 0; i < axes.size(); i++ ){
       int u = (int)map( i, 0, axes.size()-1, u0+20, u0+w-20 );
       axes.get(i).setPosition( u, v0, 10, h ); 
     }
     
     
   }
   
   int buffer = 5;
   
   void draw() {
    stroke(0);
    fill(255);
    
     //set position for each axis incorporated with swapping axes interaction
     updatePositions();      
     
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
      //interaction
      for( int i : selectedPoints ){
         
         float u0 = axes.get(0).getU(i);
         float v0 = axes.get(0).getV(i);
         for( int j = 1; j < axes.size(); j++ ){
            //determine the x,y position of the current point
            float u1 = axes.get(j).getU(i);
            float v1 = axes.get(j).getV(i);
            pushStyle();
            strokeWeight(5);  
            stroke(0, 255, 0);
            line( u0, v0, u1, v1 );
            popStyle();
            //update the x,y position of the previous point
            u0 = u1;
            v0 = v1;
         }
      }
      
      //draw the borderline of the scatterplot sketch with black
     stroke(0);
     noFill();
     rect( u0, v0, w, h );
   }
   
   //End the draw function
   

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
  
  //used for animation
  float futU = -1;
  
  PCPAxis( String attr ){
    this.attr = attr;
    data = myTable.getFloatColumn(attr);
    rmin = min(data);
    rmax = max(data);
  }
  
  //implement the setPosition
  void setPosition( int _u0, int _v0, int _w, int _h ){
      if( futU == -1 ) u0 = _u0;
      futU = _u0;
      v0 = _v0;
      w = _w;
      h = _h;
    }
  
  
  
  float getU( int idx ){ return u0; }
  
  //get the point's vertical position
  float getV( int idx ){
    return map( data[idx], rmin, rmax, v0+h-20, v0+20 );
  }
  
  void draw(){
    
    if(selected ){
      futU = u0 = mouseX;
    }
    //lerp function: linear interpolation, animation: easing motion
    u0 = (int) lerp( u0, futU, 0.05f);
    
    textSize(10);
   
   fill(0);
   
    text (attr, u0, v0 + 10);
    if( selected ){
       //drag and drop the axis
       
       
   
       u0 = mouseX; 
    }

    strokeWeight(5);
    stroke(0);
    //if the axis is selected then paint it with red
    if( selected ) stroke( 255,0,0);
    line(u0,v0 + 15,u0,v0 + h);
    
  }
  
  void mousePressed() {
      //if an axis is selected, selected = true, mouseInside() function is defined in Frame class 
      selected = mouseInside();
  }
  
  void mouseReleased() {
      selected = false;
  }
  
  
}
