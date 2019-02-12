/**
*a column data point
*a source data’s min
*a source data’s max
*a graphical data’s min
*a graphical data’s max
*distance from Point a to b
**/


class ScreenPosition{
  
  PointEntry myPoint;
  // Graph positions
  private float xPos;
  private float yPos;
 
 
  public ScreenPosition(PointEntry _myPoint, float _quantVar1, float _quantVar2){
      myPoint = _myPoint;
      xPos = _quantVar1;
      yPos = _quantVar2;
   
  }
  
  public ScreenPosition(){
      myPoint = new PointEntry();
      xPos = 0.0;
      yPos = 0.0;
   
  }
  
  //overriding the toString() method
  public String toString(){  
      return "The scaled position is at" + "(" + xPos + "," + yPos + ")";  
  }  
  float getXPos(){
    return xPos;
  }
  float getYPos(){
    return yPos;
  }
  /*void setXPos(float _xPos){
    xPos = _xPos;
  }
  
  void setYPos(float _yPos){
    yPos = _yPos;
  }*/
  
  float distanceTo(ScreenPosition b){
    return dist(xPos, yPos, b.getXPos(), b.getYPos());
  }
}
