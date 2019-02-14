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
  // Records whether this marker has been clicked (most recently)
  protected boolean clicked = false;
 
 
  public ScreenPosition(PointEntry _myPoint, float _quantVar1, float _quantVar2){
      myPoint = _myPoint;
      xPos = _quantVar1;
      yPos = _quantVar2;
   
  }
  
  public ScreenPosition(float _quantVar1, float _quantVar2){
      myPoint = new PointEntry();
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
      return myPoint.toString();  
  }  
  float getXPos(){
    return xPos;
  }
  float getYPos(){
    return yPos;
  }
  void setXPos(float _xPos){
    xPos = _xPos;
  }
  
  void setYPos(float _yPos){
    yPos = _yPos;
  }
  
  float distanceTo(ScreenPosition b){
    return dist(xPos, yPos, b.getXPos(), b.getYPos());
  }
  
  float distanceTo(float x, float y){
    return dist(xPos, yPos, x, y);
  }
  
  // Setter method for clicked field
  public void setClicked(boolean state) {
    clicked = state;
  }
  
}
