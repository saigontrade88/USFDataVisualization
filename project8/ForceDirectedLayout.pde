// most modification should occur in this file
int clickBuffer = 20;


class ForceDirectedLayout extends Frame {


  float RESTING_LENGTH = 20.0f;   // update this value, 10.0f, 0.1f, 0.05f
  float SPRING_SCALE   = 0.0075f; // update this value,  0.0075f, 20.0f
  float REPULSE_SCALE  = 200.0f;  // update this value, 400.0f

  float TIME_STEP      = 0.5f;    // probably don't need to update this

  // Storage for the graph
  ArrayList<GraphVertex> verts;
  ArrayList<GraphEdge> edges;

  // Storage for the node selected using the mouse (you 
  // will need to set this variable and use it) 
  GraphVertex selected = null;
  ArrayList<GraphEdge> selectedEdges = null;
  boolean locked = false; 

  //Dijkstras's parameters

  private HashMap<String, Integer> dist; //the total cost to the source node
  private float distMatrix[][];
  private Set<String> settled; // list of visited nodes
  private PriorityQueue<GraphVertex> pq; //minimum parity queue
  HashMap<String, ArrayList<String>> adj;


  //Dijkstras's parameters

  ForceDirectedLayout( ArrayList<GraphVertex> _verts, ArrayList<GraphEdge> _edges, HashMap<String, ArrayList<String>> _adj) {
    verts = _verts;
    edges = _edges;
    //selectedEdges = new ArrayList<GraphEdge>();

    adj = _adj;

    distMatrix = new float [verts.size()][verts.size()];

    //Intiaize the above 2D distance matrix
    initializeDistanceMatrix();

    settled = new HashSet<String> ();

    pq = new PriorityQueue<GraphVertex>(verts.size(), new GraphVertex());
  }
  //End constructor

  void applyRepulsiveForce( GraphVertex v0, GraphVertex v1 ) {
    // TODO: PUT CODE IN HERE TO CALCULATE (AND APPLY) A REPULSIVE FORCE

    //  v0.addForce( ... );
    // v1.addForce( ... );

    checkVertex(v0);

    checkVertex(v1);

    // the direction of the repulsive force that vertex 0 exerts on vertex 1
    // sub means v1 - v0
    PVector unitVect = PVector.sub(v1.getPosition(), v0.getPosition());

    // Normalize and scale the force vector to 1 distance unit so only direction matters.
    unitVect.normalize();

    float d = (v0.getPosition()).dist(v1.getPosition());

    // Limiting the distance to eliminate "extreme" results
    // for very close or very far objects
    //d = constrain(d, 5, 25);


    float repulsiveFrc = REPULSE_SCALE * ( v0.mass * v1.mass ) / sq(d);

    //v1 exerts force on v0 so added the repulsive force to the current positions of v0
    v0.addForce(repulsiveFrc * (-unitVect.x), repulsiveFrc * (-unitVect.y));

    v1.addForce(repulsiveFrc * (+unitVect.x), repulsiveFrc * (+unitVect.y));
  }
  //End applyRepulsiveForce method

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
  //End applySpringForce
  void checkVertex(GraphVertex v0) {

    float xPos = v0.getPosition().x;
    float yPos = v0.getPosition().y;

    if (xPos < 0 || xPos > width) {
      float _xPos = constrain(xPos, 0, width);
      v0.setPosition(_xPos, yPos);
    }

    if (yPos < 0 || yPos > height) {
      float _yPos = constrain(yPos, 0, width);
      v0.setPosition(xPos, _yPos);
    }
  }
  //End checkVertex method
  void checkEdge(GraphEdge e, float minDist) {

    GraphVertex v0 = e.v0;
    GraphVertex v1 = e.v1;

    PVector v0Pos = v0.getPosition();
    PVector v1Pos = v1.getPosition();

    if ( v0Pos.dist(v1Pos) <= minDist ) {

      v0.setPosition(v0Pos.x, v0Pos.y);
      v1.setPosition(v1Pos.x, v1Pos.y);
    }
  }
  //End checkEdge method
  //Dijkstra
  //Function for Dikstra's algorithm
  public void dijkstra(String srcNodeId) {

    for (GraphVertex v : verts) {
      if (!dist.containsKey(v.id)) {
        dist.put(v.id, Integer.MAX_VALUE);
      } else {
        System.out.println("Double check initialization of the distance hashmap");
        dist.put(v.id, Integer.MAX_VALUE);
      }
    }

    // Add source node to the priority queue
    GraphVertex srcNode = null;
    for (GraphVertex v : verts) {
      if (v.id.equals(srcNodeId)) {
        srcNode = v;
        break;
      }
    }
    pq.add(srcNode);

    //Distance to the source node is 0
    dist.put(srcNode.id, 0);

    //Reset the visited vertex
    if (settled.size()== verts.size())
      settled.clear();

    while (settled.size() != verts.size()) {
      //remove the minimum distance node 
      //from  the priority queue
      String u = pq.remove().id; //u = 0 for the first loop

      //adding the node whose distance is finalized
      settled.add(u);

      //System.out.println("The visting nodes are ordered as  " + u);
      //update adjacent's total distance to the source node
      e_Neighbors(srcNode);
    }
  }
  //End Dijkstra
  //Function to process all the neighbors 
  // of the visited node
  private void e_Neighbors(GraphVertex srcNode) {

    int edgeDistance = -1;
    int newTotalDistance = -1;

    //All the neighbors of u
    for (int i = 0; i < adj.get(srcNode.id).size(); i++) {

      String destId = adj.get(srcNode.id).get(i);

      // Add source node to the priority queue
      GraphVertex destNode = null;
      for (GraphVertex v : verts) {
        if (v.id.equals(destId)) {
          destNode = v;
          break;
        }
      }

      //if the node v hasn't been processed
      if (!settled.contains(destId)) {
        edgeDistance = destNode.cost;
        newTotalDistance = dist.get(srcNode.id) + edgeDistance;

        // If new distance is cheaper in cost
        if (newTotalDistance < destNode.cost)
          dist.put(destId, newTotalDistance);

        // Add the node v to the queue
        pq.add(destNode);
      }
    }
  }
  //end e_Neighbors
  //Initialize the original 2 dimensional distance matrix based on the weighted property of a GraphEdge object
  void initializeDistanceMatrix() {
    //Initialize the matrix
    for (int row = 0; row < verts.size(); row++) {
      for (int col = 0; col < verts.size(); col++) {
        distMatrix[row][col] = 0;
      }
    }
    //Update the square matrix
    for ( GraphEdge e : edges ) {
      int srcId =  e.v0.dId;
      int destId =  e.v1.dId;
      for (int row = 0; row < verts.size(); row++) {
        for (int col = 0; col < verts.size(); col++) {
          if ( row == srcId && col == destId ) {
            distMatrix[srcId][destId] = e.weight;
            distMatrix[destId][srcId] = e.weight;
          } else if (row == col) {
            distMatrix[row][col] = 0;
          }
        }
      }
    }
    //print out the distance matrix
    /**
    System.out.println("Double check the distance matrix");
    for (int row = 0; row < verts.size(); row++) {
      System.out.println("The current row is " + row);
      for (int col = 0; col < verts.size(); col++) {
        System.out.print(distMatrix[row][col] + "    ");
      }
      System.out.println();
    }*/
  }
  //end Initialize the original 2 dimensional distance matrix
  void draw() {
    update(); // don't modify this line

    // TODO: ADD CODE TO DRAW THE GRAPH

    display();

    for ( GraphEdge e : edges ) {
      checkEdge(e, 5);
    }

    //Interaction: fill adjacency vertex
    if (selected != null ) {

      selected.display();

      //loop through the edge list

      for (int j = 0; j < edges.size(); j++) {
        if (edges.get(j).v0.getID().equals(selected.getID()) == false) {
          //Redraw
          //println(selected.getID() + " talks to " + "\t" + edges.get(j).v1.getID());

          //solve the bigger case, deemphasize by coloring blue
          stroke(200);
          fill(200);
          //redraw the source, destination vertexes and the conneccting edge
          ellipse(edges.get(j).v0.getPosition().x, edges.get(j).v0.getPosition().y, 8, 8);
          ellipse(edges.get(j).v1.getPosition().x, edges.get(j).v1.getPosition().y, 8, 8);

          //stroke(0, 0, 255);

          line(edges.get(j).v0.getPosition().x, edges.get(j).v0.getPosition().y, edges.get(j).v1.getPosition().x, edges.get(j).v1.getPosition().y);

          // return black
          fill(0);
          stroke(0);// return black
        }
      } // End if loop through the edge list
    }// End if the vertex is selected
    //Draw the adjacency list of the selected vertex
    if (selectedEdges != null ) {
      //Redraw the selected edge list
      for ( GraphEdge e : selectedEdges ) {

        float vertSrcX =  e.v0.getPosition().x;
        float vertSrcY =  e.v0.getPosition().y;

        float vertDestX =  e.v1.getPosition().x;
        float vertDestY =  e.v1.getPosition().y;

        //System.out.println(vertSrcX + "\t" + vertSrcY + "\n");

        //System.out.println(vertDestX + "\t" + vertDestY + "\n");

        //solve the bigger case, deemphasize by coloring blue
        fill(255, 0, 0);
        //redraw the source, destination vertexes and the conneccting edge

        ellipse(e.v0.getPosition().x, e.v0.getPosition().y, 8, 8);
        e.v0.display();
        ellipse(e.v1.getPosition().x, e.v1.getPosition().y, 8, 8);
        e.v1.display();

        stroke(255, 0, 0);

        line(vertSrcX, vertSrcY, vertDestX, vertDestY);

        fill(0);// return black
        stroke(0);// return black
      } //End redraw the selected edge list
    } //End if check the selected edge list is not null
    //Drag and drop
    if (selected != null ) {
      //drag and drop the vertex
      if (locked) {
        selected.mouseDragged();
      }
    }
  }//End function draw



  void display() {
    for ( GraphVertex v : verts ) {

      float vertX =  v.getPosition().x;
      float vertY =  v.getPosition().y;

      //System.out.println(vertX + "\t" + vertY + "\n");
      //colorMode(HSB, 100);
      int myColor = (int) map(v.group, 1, 10, 100, 255);

      fill(0, myColor, myColor);
      ellipse(vertX, vertY, 8, 8);
      fill(0);
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
  //End function display

  boolean mouseInside(GraphVertex v) {
    PVector m = new PVector(mouseX, mouseY);
    return abs(v.getPosition().dist(m)) < clickBuffer;
  }

  void mousePressed() { 
    // TODO: ADD SOME INTERACTION CODE
    //Interaction: print ID 
    for ( GraphVertex v : verts ) {
      if (mouseInside(v)) {
        //reset the selected edge list
        selectedEdges = new ArrayList<GraphEdge>();
        selected = v;

        locked = true;//Drag and drop interaction

        //println(selected.getID(), selected.group );
        //Build the adjacency list of the selected edge above
        for (int j = 0; j < edges.size(); j++) {
          if (edges.get(j).v0.getID().equals(selected.getID()) == true) {     
            selectedEdges.add(edges.get(j));
          }
        }
      }
    }
  }//end mousePressed



  void mouseReleased() {    
    // TODO: ADD SOME INTERACTION CODE
    locked = false;
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
