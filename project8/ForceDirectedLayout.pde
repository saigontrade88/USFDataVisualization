// most modification should occur in this file


class ForceDirectedLayout extends Frame {
  
  
  float RESTING_LENGTH = 10.0f;   // update this value, 10.0f, 0.1f, 0.05f
  float SPRING_SCALE   = 0.0075f; // update this value,  0.0075f, 20.0f
  float REPULSE_SCALE  = 400.0f;  // update this value, 400.0f

  float TIME_STEP      = 0.5f;    // probably don't need to update this

  // Storage for the graph
  ArrayList<GraphVertex> verts;
  ArrayList<GraphEdge> edges;

  // Storage for the node selected using the mouse (you 
  // will need to set this variable and use it) 
  GraphVertex selected = null;
  

  ForceDirectedLayout( ArrayList<GraphVertex> _verts, ArrayList<GraphEdge> _edges ) {
    verts = _verts;
    edges = _edges;
  }

  void applyRepulsiveForce( GraphVertex v0, GraphVertex v1 ) {
    // TODO: PUT CODE IN HERE TO CALCULATE (AND APPLY) A REPULSIVE FORCE
    
     //  v0.addForce( ... );
    // v1.addForce( ... );
    
    
    // the direction of the repulsive force that vertex 0 exerts on vertex 1
    // sub means v1 - v0
    PVector unitVect = PVector.sub(v1.getPosition(), v0.getPosition());
    
    // Normalize and scale the force vector to 1 distance unit so only direction matters.
    unitVect.normalize();
          
    float d = (v0.getPosition()).dist(v1.getPosition());
    
    // Limiting the distance to eliminate "extreme" results
    // for very close or very far objects
    d = constrain(d, 5, 25);
    
    
    float repulsiveFrc = REPULSE_SCALE * ( v0.mass * v1.mass ) / sq(d);
     
    //v1 exerts force on v0 so added the repulsive force to the current positions of v0
    v0.addForce(repulsiveFrc * (-unitVect.x), repulsiveFrc * (-unitVect.y));
    
    v1.addForce(repulsiveFrc * (+unitVect.x), repulsiveFrc * (+unitVect.y));
       
  }

  void applySpringForce( GraphEdge edge ) {
    // TODO: PUT CODE IN HERE TO CALCULATE (AND APPLY) A SPRING FORCE
    
    // the direction of the attractive force that vertex 0 exerts on vertex 1
    // sub means v1 - v0
    PVector unitVect = PVector.sub(edge.v1.getPosition(), edge.v0.getPosition());
    
    // Normalize and scale the force vector to 1 distance unit so only direction matters.
    unitVect.normalize();
    
    // determine the distance
    float d = (edge.v0.getPosition()).dist(edge.v1.getPosition());
    
    // determin the force magnitude
    float springForce =  SPRING_SCALE * max(0, d - RESTING_LENGTH);
    
    //println(springForce);
    //v1 exerts force on v0 so added the attractive force to the current positions of v0
    edge.v0.addForce( springForce * (unitVect.x), springForce * (unitVect.y) );
    // 
    edge.v1.addForce( springForce * (-unitVect.x), springForce * (-unitVect.y) );
    
  }
  
  void checkVertex(GraphVertex v0){
    
    float xPos = v0.getPosition().x;
    float yPos = v0.getPosition().y;
    
    if(xPos < 0 || xPos > width){
        v0.setPosition(0, yPos);
    }
    
    if(yPos < 0 || yPos > height){
        v0.setPosition(xPos, 0);
    }
    
  }
  
  void checkEdge(GraphEdge e, float minDist){
    
    GraphVertex v0 = e.v0;
    GraphVertex v1 = e.v1;
    
    PVector v0Pos = v0.getPosition();
    PVector v1Pos = v1.getPosition();
    
    if( v0Pos.dist(v1Pos) <= minDist ){
      
      v0.setPosition(v0Pos.x, v0Pos.y);
      v1.setPosition(v1Pos.x, v1Pos.y);
      
    }
    
  }

  void draw() {
    update(); // don't modify this line
    
    // TODO: ADD CODE TO DRAW THE GRAPH
    
    display();
    
    for ( GraphEdge e : edges ) {
        checkEdge(e, 10);
    }
    
    
    
    
  }
  
  void display(){
    for ( GraphVertex v : verts ) {
      
      int vertX = (int) v.getPosition().x;
      int vertY = (int) v.getPosition().y;
      
      //System.out.println(vertX + "\t" + vertY + "\n");
      
      ellipse(vertX, vertY, 8, 8);
    }
    
    for ( GraphEdge e : edges ) {
           
      float vertSrcX =  e.v0.getPosition().x;
      float vertSrcY =  e.v0.getPosition().y;
      
      float vertDestX =  e.v1.getPosition().x;
      float vertDestY =  e.v1.getPosition().y;
      
      //System.out.println(vertSrcX + "\t" + vertSrcY + "\n");
      
      //System.out.println(vertDestX + "\t" + vertDestY + "\n");
      
      line(vertSrcX, vertSrcY, vertDestX, vertDestY);
    }
  }


  void mousePressed() { 
    // TODO: ADD SOME INTERACTION CODE

  }

  void mouseReleased() {    
    // TODO: ADD SOME INTERACTION CODE

  }



  // The following function applies forces to all of the nodes. 
  // This code does not need to be edited to complete this 
  // project (and I recommend against modifying it).
  void update() {
    for ( GraphVertex v : verts ) {
      v.clearForce();
    }

    for ( GraphVertex v0 : verts ) {
      for ( GraphVertex v1 : verts ) {
        if ( v0 != v1 ) applyRepulsiveForce( v0, v1 );
      }
    }

    for ( GraphEdge e : edges ) {
      applySpringForce( e );
    }

    for ( GraphVertex v : verts ) {
      v.updatePosition( TIME_STEP );
    }
  }
}
