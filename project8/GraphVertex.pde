// You shouldn't need to modify anything in this file but you can if you want


public static final float DAMPING_COEFFICIENT = 0.75f;


public class GraphVertex implements Comparator<GraphVertex>{

  String id;
  PVector pos = new PVector(0, 0);  
  PVector acc = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector frc = new PVector(0, 0);
  float mass = 1;
  float diam = 1;
  int group;
  
  
  /****Dijkstras*****/
  int dId;
  //int predecessor;
  float cost;
  /****Dijkstras*****/

  public GraphVertex() {}
  public GraphVertex( String _id, int _group, float _x, float _y, int _dId) {
    id = _id;
    group = _group;
    pos.set(_x, _y);
    dId = _dId;
  }
  public GraphVertex(String _id, int _dId, float _cost){
    id = _id;
    dId = _dId;
    cost = _cost;
  }
  
  public GraphVertex(int _dId, float _cost){
    
    dId = _dId;
    cost = _cost;
  }

  public String getStringID() { 
    return id;
  }
  
  public int getNumbID(){
    return dId;
  }
  
  public int getCost(){
    return (int) cost;
  }

  public void    setPosition( float _x, float _y ) { 
    pos.set(_x, _y);
  }
  public PVector getPosition() { 
    return pos;
  }

  public void    setMass( float m ) { 
    mass = m;
  }
  public float   getMass( ) { 
    return mass;
  }

  public void    setDiameter( float d ) { 
    diam = d;
  }
  public float   getDiameter( ) { 
    return diam;
  }

  public void    setVelocity( float _vx, float _vy ) { 
    vel.set(_vx, _vy);
  }
  public PVector getVelocity() { 
    return vel;
  }

  public void    setAcceleration( float _ax, float _ay ) { 
    acc.set(_ax, _ay);
  }
  public PVector getAcceleration() { 
    return acc;
  }

  public void    clearForce( ) { 
    frc.set(0, 0);
  }
  public void    addForce( float _fx, float _fy ) { 
    frc.x+=_fx; 
    frc.y+=_fy;
  }
  public PVector getForce() { 
    return frc;
  }


  // the following code probably shouldn't be modified unless you know what you're doing.
  void updatePosition( float deltaT ) {

    float accelerationX = frc.x / mass;
    float accelerationY = frc.y / mass;

    setAcceleration(accelerationX, accelerationY);

    float velocityX = (vel.x + deltaT * accelerationX) * DAMPING_COEFFICIENT;
    float velocityY = (vel.y + deltaT * accelerationY) * DAMPING_COEFFICIENT;

    setVelocity(velocityX, velocityY);    

    float x = (float) (pos.x + deltaT * velocityX + accelerationX * Math.pow(deltaT, 2.0f) / 2.0f);
    float y = (float) (pos.y + deltaT * velocityY + accelerationY * Math.pow(deltaT, 2.0f) / 2.0f);

    setPosition( x, y );
  } 

  void mouseDragged() {
    
    setPosition( mouseX, mouseY );
 
  }

  void display() {
    String pop = getStringID();
    textSize(12);
    //rectMode(CORNER);
    fill(255); // Set fill to white to draw background rectangle

    //pushMatrix();

    //(0,0) - the origin point
    //translate( getPosition().x, getPosition().y);
    rect(getPosition().x + 3, getPosition().y -18, textWidth(pop), 15);

    // Draw background rectangle
    fill(0); // Reset fill
    //text(pop, selected.getPosition().x + 3, selected.getPosition().y -18);

    //popMatrix();

    textAlign(LEFT, TOP);
    text(pop, getPosition().x + 3, getPosition().y -18);
  }

  //End the draw() function
  
  @Override
    public int compare(GraphVertex node1, GraphVertex node2) {
      
      if(node1.cost < node2.cost) return -1;
      if(node1.cost > node2.cost) return 1;
      return 0;
      
    }
    
    
}
