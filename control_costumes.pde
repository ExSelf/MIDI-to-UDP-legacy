boolean editing;
String name;

void mouseReleased() {
  if (mouseX > (const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address)) &&
    mouseX < (const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address) + const_channels_x * int(channels) - 10) &&
    mouseY > const_first_y &&
    mouseY < const_first_y + ((costumes_to_list - 1) * 20)) {
    JSONArray index = ctrl.getJSONArray(costume_to_control);
    boolean is_reacting = index.getBoolean(channel_to_control);
    index.setBoolean(channel_to_control, !is_reacting);

    println( "Change channel for costume " +(costume_to_control+1)+ " channel " + channel_to_control);
    saveJSONArray(ctrl, "costumes.json");
  } else if (mouseX > (const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address) + const_channels_x * int(channels)) &&
    mouseY > const_first_y &&
    mouseY < const_first_y + ((costumes_to_list - 1) * 20)) {
    sendPacket(2, (costume_to_control+1), 0);
  }

  if ((mouseX > const_first_x + const_num_x) && (mouseX < const_first_x + const_num_x + const_name_x)) {
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
