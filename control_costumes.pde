int control_table_x = 650;
boolean editing;
String name;

void mouseReleased() {
  if (mouseX > control_table_x &&
    mouseX < control_table_x + 275 &&
    mouseY > 15 &&
    mouseY < 35 + ((c-1)*20)) {
    JSONArray index = ctrl.getJSONArray(costume_to_control);
    boolean is_reacting = index.getBoolean(channel_to_control);
    index.setBoolean(channel_to_control, !is_reacting);

    println( "Change channel for costume " +(costume_to_control+1)+ " channel " + channel_to_control);
    saveJSONArray(ctrl, "costumes.json");
  }

  if ((mouseX > 40) && (mouseX < 210)) {
    if (!editing) {
//      editing = true;
      JSONArray index = ctrl.getJSONArray(costume_to_control);
      name = index.getString(0);
    }
  }
}

void keyPressed() {
  // If the return key is pressed, save the String and clear it
  if (keyCode == ENTER) {
    editing = false;
    JSONArray index = ctrl.getJSONArray(costume_to_control);
    index.setString(0, name);
    saveJSONArray(ctrl, "costumes.json");

    name = "";
  } else if (keyCode == ESC) {
    editing = false;
  } else if (keyCode == BACKSPACE) {
    int l = name.length();
    if (l > 0) {
      name = name.substring(0, l-1);
    }
  } else if (keyCode == SHIFT || keyCode == TAB || key == 157) {
  } else {
    name = name + key;
  }
}
