class ScreenPosition{
  
  PointEntry myPoint;
  private float xPos;
  private float yPos;
 // private float quantVar3;
 // private float quantVar4;
 // public PointEntry(float _quantVar1, float _quantVar2, float _quantVar3, float _quantVar4 )
 
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
  
  
  
  
  
}
