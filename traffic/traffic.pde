import org.gicentre.utils.stat.*;
import controlP5.*;
import org.gicentre.utils.colour.*;
ControlP5 cp5;
DropdownList statePicker;

BarChart stateBarChart, 
droveBarChart, 
carpoolBarChart, 
publicBarChart, 
walkedBarChart, 
otherBarChart, 
homeBarChart;

Textlabel stateLabel;
ColourTable colors = ColourTable.getPresetColourTable(ColourTable.SET1_9, 0, 10);
int cnt = 0;
JSONArray data;


void setup() {
  smooth();
  size(1100, 500);
  cp5 = new ControlP5(this);
  statePicker = cp5.addDropdownList("myList-d1")
    .setPosition(100, 100)
      ;

  stateLabel = cp5.addTextlabel("stateLabel")
    .setText("")
      .setPosition(100, 3)
        .setColorValue(0xFF)
          ;

  data = loadJSONArray("CommuterData.json");
  customize(statePicker, data);

  setData(data);

  // (vis1) for each state, create a chart from its commuter values
  // (vis2) calculate percentages for each value in each state
  // (vis2) for a given category and range of percentages, find top 3 states

  createChart(1.0);
  //createSubChart("Walked", 0, 0, 0, false);
  createSubCharts(0, 100000000, false);
}

void setData(JSONArray data) {
  this.data = data;
}

JSONArray getData() {
  return data;
}

void draw()
{
  background(255);
  stateBarChart.draw(15, 15, 470, 470);
  droveBarChart.draw(500, 100, 200, 150);
  carpoolBarChart.draw(700, 100, 200, 150);
  publicBarChart.draw(900, 100, 200, 150);
  walkedBarChart.draw(507, 320, 200, 150);
  otherBarChart.draw(707, 320, 200, 150);
  homeBarChart.draw(907, 320, 200, 150);
  
}

void customize(DropdownList ddl, JSONArray data) {
  // a convenience function to customize a DropdownList
  ddl.setPosition(0, 15);
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(15);
  ddl.captionLabel().set("States");
  ddl.captionLabel().style().marginTop = 3;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
  for (int i = 0; i < data.size (); i++) {     
    JSONObject c = data.getJSONObject(i); 
    ddl.addItem(c.getString("State"), i);
  }
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    createChart(theEvent.getGroup().getValue());
    draw();
  } else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

void createChart(float index) {
  data = getData();
  JSONObject c = data.getJSONObject((int) index);
  float[] chartData = {
    c.getInt("Drove Alone"), 
    c.getInt("Car-pooled"), 
    c.getInt("Used Public Transportation"), 
    c.getInt("Walked"), 
    c.getInt("Other"), 
    c.getInt("Worked at home")
    };


  stateBarChart = new BarChart(this);
  stateBarChart.setData(chartData);

  // Scaling
  stateBarChart.setMinValue(0);
  stateBarChart.setMaxValue(c.getInt("Total Workers"));

  // Axis appearance
  textFont(createFont("Helvetica", 10), 10);   
  stateBarChart.showValueAxis(true);
  stateBarChart.setBarLabels(new String[] {
    "Drove alone", "Carpooled", "Public transit", 
    "Walked", "Other", "Worked at home"
  }
  );
  stateBarChart.showCategoryAxis(true);

  float[] barColors = {
    0, 1, 2, 3, 4, 6
  };
  stateBarChart.setBarColour(barColors, colors);
}

void createSubCharts(int min, int max, boolean percent) {
  String[] categories = {
    "Drove Alone", "Car-pooled", "Used Public Transportation", 
    "Walked", "Other", "Worked at home"};
  String[] driveResults = findTopThree(categories[0], min, max);
  String[] carResults = findTopThree(categories[1], min, max);
  String[] publicResults = findTopThree(categories[2], min, max);
  String[] walkedResults = findTopThree(categories[3], min, max);
  String[] otherResults = findTopThree(categories[4], min, max);
  String[] workedResults = findTopThree(categories[5], min, max);
  droveBarChart = new BarChart(this);
  carpoolBarChart = new BarChart(this);
  publicBarChart = new BarChart(this);
  walkedBarChart = new BarChart(this);
  otherBarChart = new BarChart(this);
  homeBarChart = new BarChart(this);
  
  chartSetup(droveBarChart, driveResults, 0, 300, 300);
  chartSetup(carpoolBarChart, carResults, 1, 300, 300);
  chartSetup(publicBarChart, publicResults, 2, 300, 300);
  chartSetup(walkedBarChart, walkedResults, 3, 300, 300);
  chartSetup(otherBarChart, otherResults, 4, 300, 300);
  chartSetup(homeBarChart, workedResults, 6, 300, 300);
  
  // get number of people in that category for each of those states
  // display data/legend in either ints or percent
}

void chartSetup(BarChart b, String[] chartData, int c, int x, int y) {
  println(chartData);
  float[] values = {float(chartData[3]), 
                   float(chartData[4]),
                   float(chartData[5])};
  println("hello");
  println(values);
  b.setData(values);
  // Scaling
  b.setMinValue(0);
  b.setMaxValue(float(chartData[3]));
  // Axis appearance
  textFont(createFont("Helvetica", 10), 10);   
  b.showValueAxis(true);
  b.setBarLabels(new String[] {
    chartData[0], chartData[1], chartData[2]
  }
  );
  b.showCategoryAxis(true);

  b.setBarColour(new float[] {c, c, c}, colors);

}

void highlightStateBar(BarChart b, PVector bar, int i) {
  float[] barColors = {
    0, 1, 2, 3, 4, 6
  };
  float[] f = bar.array();
  barColors[(int) f[0]] = 5;
  b.setBarColour(barColors, colors);

  //display label
  float[] data = b.getData();
  stateLabel.setText((int) data[(int)f[0]] + " people");
}

void mouseMoved() {
  PVector result = stateBarChart.getScreenToData(new PVector(mouseX, mouseY));
  //PVector droveResult = droveBarChart.getScreenToData(new PVector(mouseX, mouseY));
  //PVector carpoolBarChart = carpoolBarChart.getScreenToData(new PVector(mouseX, mouseY));
  //PVector publicBarChart = publicBarChart.getScreenToData(new PVector(mouseX, mouseY));
  //PVector walkedBarChart = walkedBarChart.getScreenToData(new PVector(mouseX, mouseY));
  //PVector otherBarChart = otherBarChart.getScreenToData(new PVector(mouseX, mouseY));
  //PVector homeBarChart = homeBarChart.getScreenToData(new PVector(mouseX, mouseY));

  if (result != null) {
    highlightStateBar(stateBarChart, result, 6);
    highlightStateBar(droveBarChart, result, 3);
  }
//  if (result != null) {
//    highlightStateBar(droveBarChart, result);
//  }
//  if (result != null) {
//    highlightStateBar(carpoolBarChart, result);
//  } 
//  if (result != null) {
//    highlightStateBar(publicBarChart, result);
//  }
//  if (result != null) {
//    highlightStateBar(walkedBarChart, result);
//  }
//  if (result != null) {
//    highlightStateBar(otherBarChart, result);
//  }
//  if (result != null) {
//    highlightStateBar(homeBarChart, result);
//  }
}

String[] findTopThree(String category, int min, int max) {
  data = getData();
  int a = 0, b = 0, c = 0;
  String aName = "", bName = "", cName = "";
  for (int i = 1; i < data.size (); i++) {  
    JSONObject o = data.getJSONObject(i);
    int cur = o.getInt(category);
    if (min <= cur && max >= cur) {
      if (cur > a) {
        c=b;
        b=a;
        a=cur;
        cName = bName;
        bName = aName;
        aName = o.getString("State");
      } else if (cur>b) {
        c=b;
        b=cur;
        cName = bName;
        bName = o.getString("State");
      } else if (cur>c) {
        c=cur;
        cName = o.getString("State");
      }
    }
  }
  String[] result = {
    aName, bName, cName, a + "", b + "", c + ""
  };  
  return result;
}


