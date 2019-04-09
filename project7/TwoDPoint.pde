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
  
  public TwoDPoint(TwoDPoint p){
      xVal = p.getXVal();
      yVal = p.getYVal();
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
    
  private void colorDetermineXVal(float THRESHOLD_INTERMEDIATE_SATM, 
  float THRESHOLD_HIGH_SATM,
  float THRESHOLD_INTERMEDIATE_SATV,
  float THRESHOLD_HIGH_SATV) {
    
    //int yellow = color(255, 255, 0);
    //int blue= color(0,0,255);
    //int red= color(255,0,0);
    if( getXVal() <=THRESHOLD_INTERMEDIATE_SATM)
    //yellow
        fill(255, 255, 0);
    else if((getXVal()>THRESHOLD_INTERMEDIATE_SATM) 
    & (getXVal()<=THRESHOLD_HIGH_SATM))
    //blue
        fill(0,0,255);  
    else if((getXVal()>THRESHOLD_HIGH_SATM))
    //red
        fill(255,0,0);
  }
  
  float distanceTo(TwoDPoint b){
    return dist(xVal, yVal, b.getXVal(), b.getYVal());
  }
   
}
