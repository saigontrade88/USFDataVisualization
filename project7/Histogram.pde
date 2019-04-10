class Histogram extends Frame {
  String attr0;
  float [] data0;
  float rmin0, rmax0, rmean0, rsd0;
  int numBins; //10-15 bins is a good rule of thumb
  //Axes
  Axis[] axes = new Axis[2];
  //PVector selected = null;

  //Map data structure is very efficient!
  Map<Integer, Integer> binMap;
  Map.Entry<Integer, Integer> maxEntry;

  TwoDMarker selectedMarker = null;
  ArrayList<TwoDMarker> markers;

  //flag variable for mouse click interaction
  boolean selected = false;

  //Constructor
  Histogram( String _attr0, int _numBins ) {
    //Interaction: allow users to switch axes
    setAttributes( _attr0);

    markers = new ArrayList<TwoDMarker>();

    axes[0] = new Axis(_attr0);
    axes[1] = new Axis();

    numBins = _numBins;

    binMap = new HashMap<Integer, Integer>();
    //create the bins for the histogram
    for ( int i = 0; i < numBins; i++) {
      binMap.put(i, 0);
    }

    //readData();
  }
  //End Constructor
  //the start of class method
  void setAttributes( String _attr0) {
    attr0 = _attr0;
    //attr1 = _attr1;

    data0 = myTable.getFloatColumn(attr0);
    //data1 = myTable.getFloatColumn(attr1);

    rmin0 = min(data0);
    rmax0 = max(data0);

    //calculate the mean
    rmean0 =  mean(data0);

    //System.out.println(rmean0+"\n");

    //calculate the standard deviation based on the entire given data
    rsd0 = SD(data0, rmean0); 
    //System.out.println(rsd0 + "\n");
    
    /** Cross check the pdf function
    float []inputArray = {29, 45, 48, 50, 62, 78};
    
    for(int i=0; i < inputArray.length; i++){
        float pdf = gaussian_density(inputArray[i], 50, 10);
        System.out.println(inputArray[i] + "\t" + pdf);
    }**/
     
  }  
  /**
  * Returns the probability density function value f(x) of the Gaussian distribution
  * @param mu represents a population mean
  * @param sigma is the standard deviation of the distribution
  * @param x is the data value
  * @return the Gaussian probability density function
  */
  float gaussian_density(float x, float mu, float sigma){
    return (1/sqrt(2* PI * sq(sigma))) * exp((-1) * sq(x - mu) / (2 * sq(sigma)));
  }
  

  void plot_gaussian(){
    smooth();
    noStroke();
    fill(255);
    
    Arrays.sort(data0);
    
    float[] gaussianArray = new float[data0.length];
    
    for(int i =0; i < data0.length; i++)
        gaussianArray[i] = gaussian_density(data0[i], rmean0, rsd0);
    
    float gaussianMin = min(gaussianArray);
    float gaussianMax = max(gaussianArray);
    
    //Encode and visual the data points with a bell curve
    for (float f : data0){
          
      float gaussian = gaussian_density(f, rmean0, rsd0);
      float x = map(f, rmin0, rmax0, u0+buffer, u0+w-buffer);
      float y = map(gaussian, gaussianMin, gaussianMax, this.v0+this.h-buffer, this.v0+buffer);
      
      //System.out.println(f + "\t" + gaussian + "\t" +  y); 
      
      fill(255, 165, 0);
      ellipse(x, y, 0.02 * this.getWidth(), 0.02 * this.getWidth());
      //vertex(x, y);
    
    }
    
    
    //Encode and visual the mean with a line shape
    float gaussianMean = gaussian_density(rmean0, rmean0, rsd0);
    float x = map(rmean0, rmin0, rmax0, u0+buffer, u0+w-buffer);
    float y = map(gaussianMean, gaussianMin, gaussianMax, this.v0 + this.h-buffer, this.v0 + buffer);
    
    stroke(0);
    strokeWeight(2);
    fill(255, 0, 255);
    ellipse(x, y, 4, 4);
    line(x, y, x, this.v0 + this.h-buffer);
    fill(255);
    strokeWeight(1);
    //popMatrix();

  }
  int buffer = 20;
  //Implement the inherited method from Frame class 
  void draw() {

    stroke(0);
    fill(255);

    String title;

    title =  attr0;

    textAlign(CENTER, CENTER);    
    this.drawTextOnScreen( (this.w)/2, 18/2, 
      0, 8, title);

    readData();

    //draw horizontal axis
    int u1 = (int)map( 0, 0, numBins - 1, u0+buffer, u0+w-buffer);
    int u2 = (int)map( numBins - 1, 0, numBins - 1, u0+buffer, u0+w-buffer );

    //Vertical axis
    int v1 = (int)map( 0, 0, maxEntry.getValue(), v0+h-buffer, v0+buffer );
    int v2 = (int)map( maxEntry.getValue(), 0, maxEntry.getValue(), v0+h-buffer, v0+buffer );

    // drawAxisValue( numBins, u1, v1, 0, maxEntry.getValue(), v0+h-20, v0+20, "vertical");

    //highlight the origin 
    fill( 255, 0, 0);
    ellipse( u1 - buffer/2, v1 + buffer/2 , 0.02 * this.getWidth(), 0.02 * this.getWidth());

    axes[0].setPosition( u1 - buffer/2, v1 + buffer/2, (u2 - u1) + buffer, 0);
    axes[1].setPosition( u1 - buffer/2, v1 + buffer/2, 0, (v2 - v1) - buffer);

    axes[0].draw();

    axes[1].draw();
    
    drawBar();

    //Interaction: if the bar is selected then paint it with green
    //iteration over the HashSet data structure selectedPoints 
    for ( int i : selectedPoints ) { 

      float rectWidth = (w- 2*buffer)/(numBins);

      System.out.println(i + "\n");

      TwoDMarker m = markers.get(i);


      fill(0, 255, 0);
      //ellipse(m.getXPos(), m.getYPos(), 10, 10);
      //if( selected ) fill(255,0,0);
      rect(m.getXPos(), m.getYPos(), 
        rectWidth, + axes[1].getYPos() - m.getYPos());
    }
    
    plot_gaussian();

    //draw the borderline of the scatterplot sketch with black
    stroke(0);
    noFill();
    rect( u0, v0, w, h );
  }
  /***End method void draw()**/
  void readData() {
    //println("Inside the read Data function " + myTable.getRowCount() );
    for ( int i = 0; i < myTable.getRowCount(); i++) {
      //Determine the corresponding bin
      int x = floor(numBins*(data0[i] - rmin0) / (rmax0 - rmin0));
      if (x >= numBins)  x = numBins - 1;
      //System.out.println(x + "\t" + data0[i] + "\t" + numBins*(data0[i] - rmin0) / (rmax0 - rmin0) );
      //update bin frequency
      if (!binMap.containsKey(x)) {
        binMap.put(x, 1);
      } else {
        binMap.put(x, binMap.get(x)+1);
      }
    }

    //Find the first bin with highest frequency
    for (Map.Entry<Integer, Integer> entry : binMap.entrySet())
    {
      if (maxEntry == null || entry.getValue().compareTo(maxEntry.getValue()) > 0)
      {
        maxEntry = entry;
      }
    }
    //System.out.println("Max " + maxEntry.getKey() + "\t" + maxEntry.getValue());
    for ( int i = 0; i < myTable.getRowCount(); i++) {
      //Determine the corresponding bin
      int x = floor(numBins*(data0[i] - rmin0) / (rmax0 - rmin0));
      if (x >= numBins)  x = numBins - 1;
      //System.out.println(x + "\t" + data0[i] + "\t" + numBins*(data0[i] - rmin0) / (rmax0 - rmin0) );
      //Save the original value
      TwoDPoint tempPoint = new TwoDPoint(i, data0[i]);

      //Determine the graphical positions of each data points
      //x: the horizontal position
      //y: the vertical position
      if (!binMap.containsKey(x)) {

        System.out.println("The key is new");
        return;
      } else { 
        //System.out.println("Test " + data0[i] + " \t" + x + "\t" + binMap.get(x) );
        float xPos = map( x, 0, numBins - 1, u0+buffer, u0+w-buffer );
        //System.out.println("Test x " + data0[i] + " \t" + x + "\t" + xPos );
        float yPos = map( binMap.get(x), 0, maxEntry.getValue(), v0+h-buffer, v0+buffer );
        //System.out.println("Test y " + data0[i] + " \t" + binMap.get(x)  + "\t" + yPos );

        fill(0, 255, 0);
        //ellipse(xPos, yPos, 10, 10);

        TwoDMarker tempMarker = new TwoDMarker(tempPoint, xPos, yPos);
        markers.add(tempMarker);
      }
    }

    /** - test marker list **/
    /**
    for ( int i = 0; i < markers.size(); i++ ) {
      TwoDMarker p = markers.get(i);
      TwoDPoint temp = new TwoDPoint(markers.get(i).getTwoDPoint());
      System.out.println("Test maker list " + temp.toString() + "\t" + p.getXPos() + "\t" + p.getYPos());
    }**/

    /** - test HashMap
     //print all values in the binMap
     for(Integer myBin : binMap.keySet()){
     System.out.println(myBin + "\t" + binMap.get(myBin));
     }
     **/
  }
  //End method read data
  /**
   axes[0].setPosition( u1, v1, (u2 - u1), 0); xPos, yPos, width, height
   axes[1].setPosition( u1, v1, 0, (v2 - v1));
   **/
  void drawBar() {

    float rectWidth = (w- 2*buffer)/(numBins);

    for (Integer myBin : binMap.keySet()) {
      fill(0,0,255,100);
      float xPos =  map(myBin, 0, numBins - 1, u0+buffer, u0+w-buffer);
      float yPos =  map(binMap.get(myBin), 0, maxEntry.getValue(), v0+h-buffer, v0+buffer );
      //fill(255);
      //println("Bar chart, yPos = " + markers.get(i).getYPos());
      //ellipse(xPos, yPos, 10, 10);
      //if( selected ) fill(255,0,0);

      rect(xPos, yPos, 
        rectWidth, + axes[1].getYPos() - yPos);

      //draw the data label
      /**
      pushMatrix();
      //draw the data label
      textSize(16);
      fill(0);
      //stroke(0, 0, 0);
      translate(xPos, yPos);
      //rotate(rotate);
      textAlign(CENTER, CENTER);
      text(binMap.get(myBin), (rectWidth)/2, -5);
      popMatrix();**/
    }
  }
  //End method draw histogram

  /**start interaction ************************************************/
  void mousePressed() {
    float selDist = 10;
    for ( int i = 0; i < markers.size(); i++ ) {
      TwoDMarker temp = markers.get(i);
      float d = dist( temp.getXPos(), temp.getYPos(), mouseX, mouseY );
      if ( d < selDist ) {
        selDist = d;
        selectedMarker = temp;


        //add the point's index to the ordered Integer HashSet
        //println("Index inside of Scatterplot = " + i);
        if (!selectedPoints.contains(i)) selectedPoints.add(i);
      }
    }
  }
}
//End Histogram class
