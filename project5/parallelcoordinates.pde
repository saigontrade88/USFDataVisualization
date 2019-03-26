
class parallelcoordinates extends Frame{
  
  String attr0, attr1, attr2, attr3;
  float [] data0, data1, data2, data3;
  float rmin0, rmax0;
  float rmin1, rmax1;
  float rmin2, rmax2;
  float rmin3, rmax3;
  
  
  PVector selected = null;
  ArrayList<float[]> points = new ArrayList<float[]>();
  ArrayList<PVector> myPVectorList = new ArrayList<PVector>();
  
  //Constructor
  parallelcoordinates( String _attr0, String _attr1, String _attr2, String _attr3 ){
    //Initialize basic information
    setAttributes(_attr0, _attr1, _attr2, _attr3);
    
    //Initialize the ArrayList points of float objects
    for( int row = 0; row < myTable.getRowCount(); row++ ){
      //this ArrayList containing of the float objects is redundant
      points.add(new float[myTable.getColumnCount()]);
      //myPVectorList.add( new PVector() );
    }
    //Checkpoint 1: println("Your points array list's size. Expected =  2" + points.size());
  }
  //End Constructor
  
  void setAttributes( String _attr0, String _attr1, String _attr2, String _attr3){
    attr0 = _attr0;
    attr1 = _attr1;
    attr2 = _attr2;
    attr3 = _attr3;
    
    data0 = myTable.getFloatColumn(attr0);
    data1 = myTable.getFloatColumn(attr1);
    data2 = myTable.getFloatColumn(attr2);
    data3 = myTable.getFloatColumn(attr3);
    
    rmin0 = min(data0);
    rmax0 = max(data0);
    
    rmin1 = min(data1);
    rmax1 = max(data1);
    
    rmin2 = min(data2);
    rmax2 = max(data2);
    
    rmin3 = min(data3);
    rmax3 = max(data3);
  }
  
  int buffer = 10;
  
  void draw(){
    //update point positions
   for( int row = 0; row < points.size(); row++){
     
     print(data0[0] + "\n");
     print(data1[0] + "\n");
     print(data2[0] + "\n");
     print(data3[0] + "\n");
        
        
     float y1 = map( data0[row], rmin0,rmax0, v0+h-buffer,v0+buffer );
     float y2 = map( data1[row], rmin1,rmax1, v0+h-buffer,v0+buffer );
     float y3 = map( data2[row], rmin2,rmax2, v0+h-buffer,v0+buffer );
     float y4 = map( data3[row], rmin3,rmax3, v0+h-buffer,v0+buffer );
     
     float []input={y1, y2, y3, y4};
     
     for(int i = 0; i < input.length; i++)
        print(input[i] + "\n");
    
     points.set(row, input);
    // myPVectorList.get(i).set(x,y);  
   }
   
   println("Your points array list's size. Expected =  2" + points.size());
        
   /*
   for( PVector p : myPVectorList ){
        println("The PVector point " + j +  " X = " + p.x + ", Y = " + p.y);
        j+=1;
   }*/
   
   //update PVector
   for( float[] p : points ){  
     for( int i = 0; i < myTable.getColumnCount(); i++ ){
        PVector temp = new PVector(u0 + i*w/4 + buffer, p[i]);
        myPVectorList.add(temp);
        //myPVectorList.get(i).set(u0 + i*w/4 + buffer, p[i]);
     }
   }
   
   /* Debug
   int j = 1;
   
   for( PVector p : myPVectorList ){
        println("The PVector point " + j +  " X = " + p.x + ", Y = " + p.y);
        j+=1;
   }*/
   
   
   // draw labels  
   fill( 0 );
   text( attr0, u0 + buffer, v0);
   text( attr1, u0 + w/4 + buffer, v0);
   text( attr2, u0 + 2*w/4 + buffer, v0);
   text( attr3, u0 + 3*w/4 + buffer, v0);
          
   // draw axis
   //1st attribute's axis
   drawAxis(rmin0, rmax0, v0+h-buffer, v0+buffer, u0 + buffer);
      
   //2nd attribute's axis
   drawAxis(rmin1, rmax1, v0+h-buffer, v0+buffer, u0 + w/4 + buffer);
   
   //3rd attribute's axis
   drawAxis(rmin2, rmax2, v0+h-buffer, v0+buffer, u0 + 2*w/4 + buffer);
   
   //4th attribute's axis
   drawAxis(rmin3, rmax3, v0+h-buffer, v0+buffer, u0 + 3*w/4 + buffer);
    
   // draw tick marks and scales
   
   // draw legends
   fill( 0 );
   textSize(12);
   //println(u0 + 3*w/4);
   //println(u0 + 3*w/4 + 2*w/4);
   //text( attr0, u0 + 3*w/4 + (0.25)*w/4, v0 + 10 );
   String message = "Keyboard instructions to";
   text(message, u0 + 3*w/4 + (0.25)*w/4, v0 + 10);
   message = "Press keys 1, or 2 or 3";
   text(message, u0 + 3*w/4 + (0.25)*w/4, v0 + 30);
   message = " to swap between axes ";
   text(message, u0 + 3*w/4 + (0.25)*w/4, v0 + 50);
   
   
   
   // draw points
   /*
   stroke(0);
   strokeWeight(1);
   for( float[] p : points ){
     fill( 200 );
     //if( p == selected ) fill (255,0,0); 
     for( int i = 0; i < myTable.getColumnCount(); i++ )
        ellipse( u0 + i*w/4 + buffer, p[i], 5,5 );   
   }*/
   
   //draw lines
   strokeWeight(1);
   for( float[] p : points ){
     fill( 200 );
     for( int i = 0; i < myTable.getColumnCount()-1; i++ ){
        //ellipse( u0 + i*w/4 + buffer, p[i], 5,5 );
        line(u0 + i*w/4 + buffer, p[i], u0 + (i+1)*w/4 + buffer, p[i+1]);
     }
     
   }
   //Handle mouse click
  
   for( PVector p : myPVectorList ){
     fill( 200 );
     if( p == selected ) fill (255,0,0); 
   }
   
   
  }
  
  void drawAxis(float minVal, float maxVal, float minScaledPos, float maxScaledPos, float xPos){
    //2nd attribute's axis
    float minY = map( minVal, minVal,maxVal, minScaledPos, maxScaledPos);
    //label for the minimum
    text(minVal, xPos, minY + buffer);
    float maxY = map( maxVal, minVal,maxVal, minScaledPos, maxScaledPos);
    //label for the maximum
    text(maxVal, xPos, maxY);
    //draw the vertical axis
    line(xPos, minY, xPos, maxY);
  }
  void mousePressed(){
   
    float selDist = 5;
    println("mouse X = " + mouseX);
    println("mouse Y = " + mouseY);
    //float scaledMouseY = map( mouseY, rmin0, rmax0, v0+h-buffer, v0+buffer);
    //println("scaled mouse Y = " + scaledMouseY);
    for( PVector p : myPVectorList ){
      float d = dist( p.x,p.y, mouseX, mouseY );
      println("X-pos = " + p.x + " Y-pos = " + p.y);
      //println("You hit it! X Point pos = " + myScatterPoints.get(k).getXPos() + "," + myScatterPoints.get(k).getYPos()); 
      if( d < selDist ){
         selDist = d;
         selected = p;
      }
    }
    
  }
  
  
}
