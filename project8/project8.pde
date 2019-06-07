import java.util.*;

Frame myFrame = null;
// The files containing character coappearence in Victor Hugo’s Les Mis´erables
private String characterFile = "miserables.json";


HashMap<String, Integer> outdegreeMap = null;

void setup() {
  size(800, 800);  
  selectInput("Select a file to process:", "fileSelected");
}// End setup method

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    selectInput("Select a file to process:", "fileSelected");
  } else {
    println("User selected " + selection.getAbsolutePath());

    ArrayList<GraphVertex> verts = new ArrayList<GraphVertex>();
    ArrayList<GraphEdge>   edges = new ArrayList<GraphEdge>();

    //Adjacency vertex list
    // Map vertex to its ArrayList<String>
    // Look up the ArrayList given the vertex name
    // Return the ArrayList for the given vertex
    // Summarize the info from the GraphEdge ArrayList
    
    HashMap<Integer, ArrayList<GraphVertex>> adj = null;


    // TODO: PUT CODE IN TO LOAD THE GRAPH
    // Reading in Node in the graph are characters. 
    // Edge in the graph signify characters appearing in the same chapter of the novel

    JSONObject characterFile = loadJSONObject(selection.getAbsolutePath());
    JSONArray charaters = characterFile.getJSONArray("nodes");
    JSONArray coAppearanceNum = characterFile.getJSONArray("links");

    JSONObject myCharacter = charaters.getJSONObject(0);
    String id = myCharacter.getString("id");
    int group = myCharacter.getInt("group");

    //The first vertex
    verts.add(new GraphVertex(id, group, width/2, height/2, 0));

    Random rand = new Random();

    for (int i = 1; i < charaters.size(); i++) {

      myCharacter = charaters.getJSONObject(i);
      id = myCharacter.getString("id");
      group = myCharacter.getInt("group");

      int x = (int) rand.nextInt(width);
      int y = (int) rand.nextInt(height);

      verts.add(new GraphVertex(id, group, x, y, i));
    }

    System.out.println("Number of vertices" + verts.size() + "\n");
    //coAppearanceNum.size()
    
    /*
    for(GraphVertex v: verts){
      System.out.println(v.dId + " " + v.id); 
    }*/

    for (int i = 0; i < coAppearanceNum.size(); i++) {

      JSONObject myEdge = coAppearanceNum.getJSONObject(i);
      String srcVertString = myEdge.getString("source");
      String destVertString = myEdge.getString("target");
      float _weight = myEdge.getFloat("value");

      //System.out.println(coAppearanceNum.size() + "\t" + srcVertString + "\t" + destVertString + "\t" + _weight);


      GraphVertex mySrcVert = null;
      GraphVertex myDestVert = null;

      //edges.add(new GraphEdge( mySrcVert, myDestVert, _weight));
      //verts.size()
      //Find the source vertext in the vertex list
      for (int j = 0; j < verts.size(); j++) {
        //System.out.println("Character name= " + verts.get(j).getStringID() + "\n");
        //System.out.println(srcVertString + "\n");
        //System.out.println(verts.get(j).getStringID().equals(srcVertString));
        if (verts.get(j).getStringID().equals(srcVertString)) {
          mySrcVert =  verts.get(j);
        } else {
          //System.out.println(verts.get(j).getStringID());
          //System.out.println("Can't find the corresponding vertex");
        }
      }

      //Find the dest vertext in the vertex list
      for (int j = 0; j < verts.size(); j++) {
        //System.out.println("Character name= " + verts.get(j).getStringID() + "\n");
        //System.out.println("Character name= " + verts.get(j).getStringID() + "\n");
        if (verts.get(j).getStringID().equals(destVertString)) {
          myDestVert =  verts.get(j);
        } else {
          //System.out.println(verts.get(j).getStringID());
          //System.out.println("Can't find the corresponding vertex");
          //return;
        }
      }

      //Add to the edge list
      edges.add(new GraphEdge( mySrcVert, myDestVert, _weight));
    }//Loop over each edge

    System.out.println("Number of edges " + edges.size() + "\n");

    //create HashMap to count the source vertex occurrences
    outdegreeMap = new HashMap<String, Integer>();

    for ( GraphEdge e : edges ) {
      GraphVertex cur = e.v0;
      String curId = cur.getStringID();
      //println(curId);
      if (!outdegreeMap.containsKey(curId)) {
        outdegreeMap.put(curId, 1);
      } else {
        outdegreeMap.put(curId, outdegreeMap.get(curId) + 1);
      }
    }
    //Test Who Valjean talks to
    /**
     int counter = 0;
     for (int j = 0; j < edges.size(); j++) {
     if (edges.get(j).v0.getStringID().equals("Valjean")) {
     println("Valjean talks to " + "\t" + edges.get(j).v1.getStringID());
     counter += 1;
     if(counter > outdegreeMap.get("Valjean")){
     println("break at " + j);
     break;
     }
     }
     
     }*/

    /*
    for (String s : outdegreeMap.keySet()) {
     System.out.println(s + "\t" + outdegreeMap.get(s));
     }*/

    //Initialize the adjacency vertex list

    adj = new HashMap<Integer, ArrayList<GraphVertex>>();
    
    for ( GraphVertex v : verts ) {
      ArrayList<GraphVertex> neighborList = new ArrayList<GraphVertex>();
      adj.put(v.dId, neighborList);
    }
    
    //Populate the adjacency list
    for ( GraphEdge u : edges) {
          if (adj.containsKey(u.v0.dId)) {
            ArrayList<GraphVertex> neighborList = adj.get(u.v0.dId);
            neighborList.add(u.v1);
            adj.put(u.v0.dId, neighborList);
          } else {
            System.out.println("New vertex. Double check the input data");
          }
     }
      
    
    System.out.println("The adjacency list");
    
    for (int dId : adj.keySet()) {
      ArrayList<GraphVertex> neighborList = adj.get(dId);
      String myString = dId + " ";
      for(int i = 0; i < neighborList.size(); i++){
        myString = myString + "\t" + neighborList.get(i).id;   
      }
      System.out.println(myString);
    }
    
    System.out.println("Vertices are not included in the adjency list");
    
    for ( GraphVertex v : verts ) {
       if(!adj.containsKey(v.dId)){
         System.out.println(v.id);
    //     ArrayList<String> adjList = new ArrayList<String>();
    //     adjList.add("zero_Out_Degree");
    //     adj.put(v.id, adjList);
       }
    }
    
    myFrame = new ForceDirectedLayout( verts, edges, adj);
  }
}

void draw() {
  background( 255 );

  if ( myFrame != null ) {

    int buffer = 100;

    myFrame.setPosition( 25, 25, width - 250, height - 100);

    //Border of the frame
    //rect(myFrame.u0, myFrame.v0, myFrame.w, myFrame.h);

    myFrame.draw();

    textAlign(CENTER, CENTER);

    textAlign(CENTER, CENTER);

    String title = "Graph Directed Layout " + characterFile;
    myFrame.drawTextOnScreen((width - buffer)/2, (myFrame.v0 - 2)/2, 
      0, 16, title);

    //draw a function for title
    String ins;
    ins ="*Interactions:\n - Explore the netwrok in details \n by clicking on a source vertex.\n" + 
      "- Use your mouse to relocate \nthe vertex (ongoing). \n" +
      "* Visual encoding: red means the interested characters. \n" +
      " At the beginning, different color means different group";

    //Border of the textbox
    //rect(myFrame.u0 + myFrame.w + 10,  (myFrame.v0 - 2)/2, 
    //width - (myFrame.u0 + myFrame.w + 15), buffer);

    textAlign(LEFT, CENTER);
    myFrame.drawTextOnScreen(myFrame.u0 + 3*myFrame.w/4, 100, 
      0, 11, ins);

    //noLoop();
  }
}





void mousePressed() {
  myFrame.mousePressed();
}

void mouseReleased() {
  myFrame.mouseReleased();
}

abstract class Frame {

  int u0, v0, w, h;
  int clickBuffer = 2;
  void setPosition( int u0, int v0, int w, int h ) {
    this.u0 = u0;
    this.v0 = v0;
    this.w = w;
    this.h = h;
  }

  abstract void draw();

  void mousePressed() {
  }
  void mouseReleased() {
  }

  boolean mouseInside() {
    return (u0-clickBuffer < mouseX) && (u0+w+clickBuffer)>mouseX && (v0-clickBuffer)< mouseY && (v0+h+clickBuffer)>mouseY;
  }
  void drawTextOnScreen(float x, float y, float rotate, int textSize, String text)
  {
    pushMatrix();

    textSize(textSize);
    fill(0);
    stroke(0, 0, 0);
    //translate(x,y);
    rotate(rotate);
    //textAlign(CENTER,CENTER);
    text(text, u0 + x, v0 + y);
    fill(255);//reset to the white background

    popMatrix();
  }
  //End method draw text on screen
}
