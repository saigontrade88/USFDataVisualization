import java.util.*;

Frame myFrame = null;
// The files containing character coappearence in Victor Hugo’s Les Mis´erables
private String characterFile = "miserables.json";

void setup() {
  size(800, 800);  
  //selectInput("Select a file to process:", "fileSelected");

  ArrayList<GraphVertex> verts = new ArrayList<GraphVertex>();

  ArrayList<GraphEdge>   edges = new ArrayList<GraphEdge>();


  // TODO: PUT CODE IN TO LOAD THE GRAPH
  // Reading in Node in the graph are characters. 
  // Edge in the graph signify characters appearing in the same chapter of the novel
  JSONObject characterFile = loadJSONObject("miserables_small.json");
  JSONArray charaters = characterFile.getJSONArray("nodes");
  JSONArray coAppearanceNum = characterFile.getJSONArray("links");

  JSONObject myCharacter = charaters.getJSONObject(0);
  String id = myCharacter.getString("id");
  int group = myCharacter.getInt("group");

  verts.add(new GraphVertex(id, group, width/2, height/2));

  Random rand = new Random();
  
  for (int i = 1; i < charaters.size(); i++) {

    myCharacter = charaters.getJSONObject(i);
    id = myCharacter.getString("id");
    group = myCharacter.getInt("group");

    int x = (int) rand.nextInt(width);
    int y = (int) rand.nextInt(height);

    verts.add(new GraphVertex(id, group, x, y));
  }

  System.out.println("Number of vertices" + verts.size() + "\n");
  //coAppearanceNum.size()
  
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
      //System.out.println("Character name= " + verts.get(j).getID() + "\n");
      //System.out.println(srcVertString + "\n");
      //System.out.println(verts.get(j).getID().equals(srcVertString));
      if (verts.get(j).getID().equals(srcVertString)) {
        mySrcVert =  new GraphVertex(verts.get(j).getID(), verts.get(j).group, verts.get(j).getPosition().x, verts.get(j).getPosition().y);
      } else {
        //System.out.println(verts.get(j).getID());
        //System.out.println("Can't find the corresponding vertex");
      }
    }

    //Find the dest vertext in the vertex list
    for (int j = 0; j < verts.size(); j++) {
      //System.out.println("Character name= " + verts.get(j).getID() + "\n");
      //System.out.println("Character name= " + verts.get(j).getID() + "\n");
      if (verts.get(j).getID().equals(destVertString)) {
        myDestVert =  new GraphVertex(verts.get(j).getID(), verts.get(j).group, verts.get(j).getPosition().x, verts.get(j).getPosition().y);
      } else {
        //System.out.println(verts.get(j).getID());
        //System.out.println("Can't find the corresponding vertex");
        //return;
      }
    }

    //Add to the edge list
    edges.add(new GraphEdge( mySrcVert, myDestVert, _weight));
      
  }//Loop over each edge
  
  System.out.println("Number of edges " + edges.size() + "\n");

  myFrame = new ForceDirectedLayout( verts, edges );
}// End setup method

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    selectInput("Select a file to process:", "fileSelected");
  } else {
    println("User selected " + selection.getAbsolutePath());

    ArrayList<GraphVertex> verts = new ArrayList<GraphVertex>();
    ArrayList<GraphEdge>   edges = new ArrayList<GraphEdge>();


    // TODO: PUT CODE IN TO LOAD THE GRAPH
    // Reading in Node in the graph are characters. 
    // Edge in the graph signify characters appearing in the same chapter of the novel

    myFrame = new ForceDirectedLayout( verts, edges );
  }
}


void draw() {
  background( 255 );

  if ( myFrame != null ) {
    myFrame.setPosition( 0, 0, width, height );
    myFrame.draw();
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
}
