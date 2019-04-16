

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
  JSONObject characterFile = loadJSONObject("miserables.json");
  JSONArray charaters = characterFile.getJSONArray("nodes");
  JSONArray coAppearanceNum = characterFile.getJSONArray("links");
  
  JSONObject myCharacter = charaters.getJSONObject(0);
  String id = myCharacter.getString("id");
  int group = myCharacter.getInt("group");
    
  verts.add(new GraphVertex(id, group, 5, 5));
    

  for (int i = 1; i < charaters.size(); i++) {
    
    myCharacter = charaters.getJSONObject(i);
    id = myCharacter.getString("id");
    group = myCharacter.getInt("group");
    
    int x = (int) map(i, 1, charaters.size(), 10, width);
    int y = (int) map(i, 1, charaters.size(), 10, height);
    
    verts.add(new GraphVertex(id, group, x, y));
    
  }

  System.out.println("Number of vertices" + verts.size() + "\n");

  for (int i = 0; i < coAppearanceNum.size(); i++) {
    
    JSONObject myEdge = coAppearanceNum.getJSONObject(i);
    String srcVertString = myEdge.getString("source");
    String destVertString = myEdge.getString("target");
    float _weight = myEdge.getFloat("value");
    
    //System.out.println(coAppearanceNum.size() + "\t" + srcVertString + "\t" + destVertString + "\t" + _weight);
    
    /*
    for (int j = 0; j < verts.size(); j++) {
        System.out.println(verts.get(j).getID());
        System.out.println(trim(verts.get(j).getID()) == srcVertString);
        //System.out.println(trim(verts.get(j).getID()) + "\n");
        if (verts.get(j).getID() == srcVertString) {
           GraphVertex mySrcVert = verts.get(j);
           System.out.println(mySrcVert.getID() + "\n");
        }
    }*/
    
    GraphVertex mySrcVert = new GraphVertex( srcVertString, 1, 5, 5 );
    GraphVertex myDestVert = new GraphVertex( destVertString, 1, 5, 5 );
    
    edges.add(new GraphEdge( mySrcVert, myDestVert, _weight));
    
    /*
    for (int j = 0; j < verts.size(); i++) {
      System.out.println("Character name= " + verts.get(j).getID() + "\n");
      System.out.println("Character name= " + verts.get(j).getID() + "\n");
      if (verts.get(j).getID() == srcVertString) {
        for (int k = 0; k < verts.size(); i++) {
          if (verts.get(k).getID() == destVertString) {
            GraphVertex mySrcVert =  verts.get(j);
            GraphVertex myDestVert = verts.get(k);
            edges.add(new GraphEdge( mySrcVert, myDestVert, _weight));
          }
        }
      }
    }*/
      //edges.add(new GraphEdge( srcVert , destVert, _weight));
  }//End outer loop
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
      JSONObject characterFile = loadJSONObject("miserables.json");
      JSONArray charaters = characterFile.getJSONArray("node");
      JSONArray coAppearanceNum = characterFile.getJSONArray("link");

      for (int i = 0; i < charaters.size(); i++) {
        JSONObject myCharacter = charaters.getJSONObject(i);
        String id = myCharacter.getString("id");
        int group = myCharacter.getInt("group");

        verts.add(new GraphVertex(id, group, 5, 5));
      }

      System.out.println(verts.size() + "\n");
      /*
    for(int i = 0; i < verts.size(); i++){
       System.out.println(verts.get(i).getID()+"\n");
       
       }*/

      /*for(int i = 0; i < coAppearanceNum.size(); i++){
       JSONObject myEdge = coAppearanceNum.getJSONObject(i);
       String srcVertString = myEdge.getString("source");
       String destVertString = myEdge.getString("target");
       float _weight = myEdge.getFloat("value");
       
       for(GraphVertex srcVert: verts){
       if(srcVert.getID() == srcVertString){
       for(GraphVertex destVert: verts)
       if(destVert.getID() == destVertString){
       GraphVertex mySrcVert = srcVert;
       GraphVertex myDestVert = destVert;
       edges.add(new GraphEdge( mySrcVert , myDestVert, _weight));       
       }
       }
       }
       //edges.add(new GraphEdge( srcVert , destVert, _weight));
       }*/

      myFrame = new ForceDirectedLayout( verts, edges );
    }
  }


  void draw() {
    background( 255 );

    if ( myFrame != null ) {
      myFrame.setPosition( 0, 0, width, height );
      myFrame.draw();
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
