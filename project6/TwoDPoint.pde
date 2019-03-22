class TwoDPoint{
  
  private float xVal;
  private float yVal;
  
  public TwoDPoint(float _quantVar1, float _quantVar2){
      xVal = _quantVar1;
      yVal = _quantVar2;
  }
  
  public TwoDPoint(){
      xVal = 0.0;
      yVal = 0.0;
  }
  
  //overriding the toString() method
  public String toString(){  
      return  "(" + xVal + "," + yVal + ")";  
  }  
  float getXVal(){
    return xVal;
  }
  float getYVal(){
    return yVal;
  }
    
  private void colorDetermineXVal(float THRESHOLD_INTERMEDIATE, float THRESHOLD_HIGH) {
    
    //int yellow = color(255, 255, 0);
    //int blue= color(0,0,255);
    //int red= color(255,0,0);
    if( getXVal() <=THRESHOLD_INTERMEDIATE)
    //yellow
        fill(255, 255, 0);
    else if((getXVal()>THRESHOLD_INTERMEDIATE) & (getXVal()<=THRESHOLD_HIGH))
    //blue
        fill(0,0,255);  
    else if((getXVal()>THRESHOLD_HIGH))
    //red
        fill(255,0,0);
  }
  
  float distanceTo(TwoDPoint b){
    return dist(xVal, yVal, b.getXVal(), b.getYVal());
  }
   
}