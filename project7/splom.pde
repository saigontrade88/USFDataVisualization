

class splom extends Frame {
  Scatterplot[][] scp;
  Histogram[] hst;

  splom() {
    scp = new Scatterplot[myTable.getColumnCount()][myTable.getColumnCount()];
    hst = new Histogram[myTable.getColumnCount()];

    for ( int i = 0; i < scp.length; i++ ) {
      //Remove the categorical variable
      if (!myTable.getColumnTitle(i).equals("Class")) {
        for (int j = 0; j < scp.length; j++ ) {
          //Remove the categorical variable
          if (!myTable.getColumnTitle(j).equals("Class")) {
            if ( i > j) {        
              scp[i][j] = new Scatterplot( myTable.getColumnTitle(i), myTable.getColumnTitle(j) );
            } else if (i==j) {
              hst[j] = new Histogram(myTable.getColumnTitle(j), 10);
            } else {
              scp[i][j] = new Scatterplot( myTable.getColumnTitle(i), myTable.getColumnTitle(j) );
              ;
            }
          }
        }//End of the j loop
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
      if (!myTable.getColumnTitle(i).equals("Class")) {
        float[] data0 = myTable.getFloatColumn(myTable.getColumnTitle(i));
        for (int j = 0; j < scp.length; j++ ) {
          if (!myTable.getColumnTitle(j).equals("Class")) {
            float[] data1 = myTable.getFloatColumn(myTable.getColumnTitle(j));

            float x = map( i, 0, scp.length, u0, u0+w );
            float y = map( j, 0, scp.length, v0, v0+h );
            if ( i > j ) {
              scp[i][j].setPosition( (int)x, (int)y, w/(scp.length), h/(scp.length) );
              //println("(i,j)" + "(" + i + "," + j +")");

              // float[] data1 = myTable.getFloatColumn(myTable.getColumnTitle(j));
              float corr = correlation(data0, data1);

              String strCorr = String.format ("%,.03f", corr);

              //println(myTable.getColumnTitle(i) + "vs" + myTable.getColumnTitle(j) + "\n");
              //println("Correlation = " + corr);

              scp[i][j].draw();

              scp[i][j].drawTextOnScreen( scp[i][j].getWidth()/2, scp[i][j].h - 20, 0, 12, strCorr);
            } else if (i==j) {
              hst[j].setPosition( (int)x, (int)y, w/(scp.length), h/(scp.length) );
              hst[j].draw();
            } else {

              scp[i][j].setPosition( (int)x, (int)y, w/(scp.length), h/(scp.length) );
              //println("(i,j)" + "(" + i + "," + j +")");

              //float[] data1 = myTable.getFloatColumn(myTable.getColumnTitle(j));
              float corr = SPC(data0, data1);

              String strCorr = String.format ("%,.03f", corr);

              //println(myTable.getColumnTitle(i) + "vs" + myTable.getColumnTitle(j) + "\n");
              //println("Correlation = " + corr);

              scp[i][j].colorDetermineCorrelation(corr, 0.5, 0.6);

              scp[i][j].draw();

              scp[i][j].drawTextOnScreen( scp[i][j].getWidth()/2, scp[i][j].h - 20, 0, 12, strCorr);
            }
          }
        }//End of the inner loop
      }
    } //End of the outer loop
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
