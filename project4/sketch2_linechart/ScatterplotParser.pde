/**
* ScatterplotParser class:
* constructor(data, column1, column2)
* read method, input: a Table column, return an ArrayList of one quantitative column
*/
class ScatterPlotParser{
  
  ScatterPlotParser(){}
  
  ArrayList<PointEntry>read(String useColumnX, String useColumnY){
    
    ArrayList<PointEntry> myList = new ArrayList<PointEntry>(); 
    int xIndex = myTable.getColumnIndex(useColumnX);
    int yIndex = myTable.getColumnIndex(useColumnY);
    for (TableRow row : myTable.rows())
    {
      float quantVar1 = row.getFloat(xIndex);
      float quantVar2 = row.getFloat(yIndex);
      //println(quantVar2);
      PointEntry temp = new PointEntry(quantVar1, quantVar2);
      myList.add(temp);
    }
    print(myList.size());
    
    /*for (int k=1; k < myList.size(); k++) {
        println(myList.get(k).getXVal() - myList.get(k-1).getXVal());
    }*/ 
    return myList;
  }
}
