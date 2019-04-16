// most modification should occur in this file


class ForceDirectedLayout extends Frame {
  
  
  float RESTING_LENGTH = 10.0f;   // update this value
  float SPRING_SCALE   = 0.0075f; // update this value
  float REPULSE_SCALE  = 400.0f;  // update this value

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
    
    // v0.addForce( ... );
    // v1.addForce( ... );
  }

  void applySpringForce( GraphEdge edge ) {
    // TODO: PUT CODE IN HERE TO CALCULATE (AND APPLY) A SPRING FORCE
    
    // edge.v0.addForce( ... );
    // edge.v1.addForce( ... );
  }

  void draw() {
    update(); // don't modify this line
    
    // TODO: ADD CODE TO DRAW THE GRAPH
    for ( GraphVertex v : verts ) {
      
      int vertX = (int) v.getPosition().x;
      int vertY = (int) v.getPosition().y;
      
      System.out.println(vertX + "\t" + vertY + "\n");
      
      ellipse(vertX, vertY, 5, 5);
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
