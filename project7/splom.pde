

class splom extends Frame {
  Scatterplot[][] scp;

  splom() {
    scp = new Scatterplot[myTable.getColumnCount()][myTable.getColumnCount()];

    for ( int i = 0; i < scp.length; i++ ) {
      if (!myTable.getColumnTitle(i).equals("Class")) {
        for (int j = 0; j < scp.length; j++ ) {
          if ( i < j) {
            //Remove the categorical variable
            if (!myTable.getColumnTitle(j).equals("Class")) {
              scp[i][j] = new Scatterplot( myTable.getColumnTitle(i), myTable.getColumnTitle(j) );
              //println("(i,j)" + "(" + i + "," + j +")");
            }
          } else
            scp[i][j] = null;
        }
      }
    }
  }

  void draw() {

    String title;

    title = "Scatterplot Matrix(SPLOM)";
    //Border of the textbox

    //rect( u0, v0, w, h );
    fill(255);   

    textAlign(CENTER, CENTER);
    this.drawTextOnScreen(w/2, 18/2, 
      0, 12, title);

    for ( int i = 0; i < scp.length; i++ ) {
      for (int j = 0; j < scp.length; j++ ) {
        float x = map( i, 0, scp.length, u0, u0+w );
        float y = map( j, 0, scp.length, v0, v0+h );
        if ( scp[i][j] != null ) {
          scp[i][j].setPosition( (int)x, (int)y, w/(scp.length), h/(scp.length) );
          scp[i][j].draw();
        }
      }
    }
    //draw the borderline of the scatterplot sketch with black

    stroke(0);
    noFill();
    //rect( u0, v0, w, h );
  }
  //End the draw function
  void mousePressed() {
    for ( int i = 0; i < scp.length; i++ ) {
      for (int j = 0; j < scp.length; j++ ) {
        if ( scp[i][j] != null ) {
          scp[i][j].mousePressed();
        }
      }
    }
  }
}
