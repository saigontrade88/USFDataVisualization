

class Barchart extends Frame {

  Table data;
  String useColumn;

  Barchart( Table _data, String _useColumn ) {
    data = _data;
    useColumn = _useColumn;
  }
  int getNumberRows(){
    return this.data.getRowCount(); 
  }
  
  int getNumberFields(){
    return this.data.getColumnCount();
  }
  
  void setColumn( String _useColumn ){
    useColumn = _useColumn;
  }

  void draw() { 
  
 // rect(250, 200, 200, 150);
  }

  void mousePressed() {  }

  void mouseReleased() {   }
  
  //println(myTable.getRowCount() + " total rows in table");
    
  //  println(myTable.getColumnCount() + " total columns in table");
    
  //   for (TableRow row : myTable.rows()) {
  //   //int id = row.getInt();
  //   int myYear = row.getInt("YEAR");
     
  //   //int myYear = i;
  //   float gpa_Score = row.getFloat("GPA");
  //   int act_Score = row.getInt("ACT");
     
  //   println(myYear + " :" + " has GPA score of " + gpa_Score);
  //  // i = i + 1;
  //   }
  
}
