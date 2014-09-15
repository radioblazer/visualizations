import org.gicentre.utils.stat.*;
import controlP5.*;
import org.gicentre.utils.colour.*;
ControlP5 cp5;
DropdownList statePicker;
BarChart stateBarChart;
Textlabel stateLabel;
ColourTable colors = ColourTable.getPresetColourTable(ColourTable.SET1_9,0,10);
int cnt = 0;
JSONArray data;

void setup() {
  smooth();
  size(1000,500);
  cp5 = new ControlP5(this);
  statePicker = cp5.addDropdownList("myList-d1")
                   .setPosition(100, 100)
                   ;
                   
   stateLabel = cp5.addTextlabel("stateLabel")
                    .setText("")
                    .setPosition(100,3)
                    .setColorValue(0xFF)
                    ;

  data = loadJSONArray("CommuterData.json");
  customize(statePicker, data);
  
  setData(data);

  
  for (int i = 0; i < data.size(); i++) {     
    JSONObject c = data.getJSONObject(i); 
    println(c.getString("State"));
  }
    
  // (vis1) for each state, create a chart from its commuter values
  // (vis2) calculate percentages for each value in each state
  // (vis2) for a given category and range of percentages, find top 3 states
  
  createChart(1.0);
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
  stateBarChart.draw(15,15,470,470); 
}

void customize(DropdownList ddl, JSONArray data) {
  // a convenience function to customize a DropdownList
  ddl.setPosition(0,15);
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(15);
  ddl.captionLabel().set("States");
  ddl.captionLabel().style().marginTop = 3;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
  for (int i = 0; i < data.size(); i++) {     
    JSONObject c = data.getJSONObject(i); 
    ddl.addItem(c.getString("State"), i);
  }
  //ddl.scroll(0);
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
} 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

void createChart(float index) {
  data = getData();
  JSONObject c = data.getJSONObject((int) index);
  float[] chartData = {c.getInt("Drove Alone"), 
                     c.getInt("Car-pooled"),
                     c.getInt("Used Public Transportation"),
                     c.getInt("Walked"),
                     c.getInt("Other"),
                     c.getInt("Worked at home")};
 
  
  stateBarChart = new BarChart(this);
  stateBarChart.setData(chartData);

     
  // Scaling
  stateBarChart.setMinValue(0);
  stateBarChart.setMaxValue(c.getInt("Total Workers"));
   
  // Axis appearance
  textFont(createFont("Helvetica",10),10);   
  stateBarChart.showValueAxis(true);
  stateBarChart.setBarLabels(new String[] {"Drove alone","Carpooled","Public transit",
                                           "Walked","Other", "Worked at home"});
  stateBarChart.showCategoryAxis(true);
  
  float[] barColors = {0, 1, 2, 3, 4, 6};
  stateBarChart.setBarColour(barColors, colors);


}

void highlightStateBar(PVector bar) {

  float[] barColors = {0, 1, 2, 3, 4, 6};
  float[] f = bar.array();
  barColors[(int) f[0]] = 5;
  stateBarChart.setBarColour(barColors, colors);
   
  //display label
  float[] data = stateBarChart.getData();
  stateLabel.setText((int) data[(int)f[0]] + " people");
  
  
}

void mouseMoved() {
  PVector result = stateBarChart.getScreenToData(new PVector(mouseX, mouseY));
  if (result != null) {
    highlightStateBar(result);
  }
}

int[] findTopThree(String category, int min, int max) {
  data = getData();
  int a = 0, b = 0, c = 0;
  for (int i = 1; i < data.size(); i++) {     
    JSONObject o = data.getJSONObject(i);
    cur = o.getInt(category);
    if (min <= cur) && max >= cur) {

    }
    println(o.getString("State"));
  }
  int[] result = {a, b, c};
  return result;
    
  
}

