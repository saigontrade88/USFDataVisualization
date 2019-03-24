class Bar extends Frame {
  String attr0, attr1;
  float [] data0, data1;
  float rmin0, rmax0;
  float rmin1, rmax1;
  //Axes
  Axis[] axes = new Axis[2];
  //PVector selected = null;
  TwoDMarker selectedMarker = null;
  ArrayList<TwoDMarker> markers;
  
  //flag variable for mouse click interaction
  boolean selected = false;

  //Constructor
  Bar( String _attr0, String _attr1 ) {
    //Interaction: allow users to switch axes
    setAttributes( _attr0, _attr1 );

    markers = new ArrayList<TwoDMarker>();

    axes[0] = new Axis(_attr0);
    axes[1] = new Axis(_attr1);
    
    //readData();
    
    
  }
  //End Constructor
  //the start of class method
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
  //Implement the inherited method from Frame class 
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
    axes[1].draw();
    
    //Read the data
    
    //print("Bar chart w inside Draw =" + w);
    //print("Bar chart h  inside Draw =" + h);
    
    readData();
        
    /**  
     for (int i=0; i < markers.size(); i++) {
     println("Bar chart " + markers.get(i).toString());
     }**/
    
    drawBar();
       
    //if the bar is selected then paint it with green
    //iteration over the HashSet data structure selectedPoints 
    for ( int i : selectedPoints ) { 
        
      
      int rectWidth = (axes[0].getWidth())/myTable.getRowCount();
      
      TwoDMarker temp = markers.get(i); 
      
      fill(0, 255, 0);
      //if( selected ) fill(255,0,0);
      rect(temp.getXPos(), temp.getYPos(),
         rectWidth, + axes[1].getYPos() - temp.getYPos());
       
     }
    
    //draw the borderline of the scatterplot sketch with black
     stroke(0);
     noFill();
     rect( u0, v0, w, h );
    
    
  }
  /***End method void draw()**/
  void readData(){
    //println("Inside the read Data function " + myTable.getRowCount() );
    for ( int i = 0; i < myTable.getRowCount(); i++) {
      //Map to the horizontal axis, 
      //To do: map to width of the axes [0]
      //float x = map( data0[i], rmin0, rmax0, u0+20, u0+w-20);
      float x = map( i, 0, myTable.getRowCount(), u0+20, u0+w-20);
      //Map to the vertical axis
      //float y = map( data1[i], rmin1, rmax1, v0+h-20, v0+20 );
      float y = map( data1[i], rmin1, rmax1, v0+h-20, v0+20);
    
      TwoDPoint tempPoint = new TwoDPoint(data0[i], data1[i]);
      TwoDMarker tempMarker = new TwoDMarker(tempPoint, x, y);
      markers.add(tempMarker);
    }
  }
  //End method read data
  /**
    axes[0].setPosition( u1, v1, (u2 - u1), 0); xPos, yPos, width, height
    axes[1].setPosition( u1, v1, 0, (v2 - v1));
  **/
  void drawBar(){
      //println(markers.size());
     //println("Inside drawBar function " + myTable.getRowCount());
     float rectWidth = (axes[0].getWidth() - 40)/myTable.getRowCount();
     
     for ( int i = 0; i < myTable.getRowCount(); i++) {
         fill(80, 80, 100);
         //float xPos =  map(i, 0, myTable.getRowCount(), u0+20, u0+w-20);
         fill(255);
         //println("Bar chart, yPos = " + markers.get(i).getYPos());
         //ellipse(markers.get(i).getXPos(), markers.get(i).getYPos(), 10, 10);
         //if( selected ) fill(255,0,0);
         rect(markers.get(i).getXPos(), markers.get(i).getYPos(),
         rectWidth, + axes[1].getYPos() - markers.get(i).getYPos());
       
     }
     
  }
  //End method draw bar chart
  
  /**start interaction ************************************************/
  void mousePressed(){
    
  }
}
//End Bar class
  
