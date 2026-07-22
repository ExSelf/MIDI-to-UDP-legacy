int last_midi_message;

void midiMessage(MidiMessage message) { // // You can also use midiMessage(MidiMessage message, long timestamp, String bus_name)
  if (message.getStatus() > 143 && message.getStatus() < 160) {
    if (midi_console) println();
    int ch = message.getStatus() - 143;
    if (midi_console) println("Channel: " + ch);
    int c = (message.getMessage()[1] & 0xFF);
    if (midi_console) println("Command: " + c);
    int p = (message.getMessage()[2] & 0xFF);
    if (midi_console) println("Parameter: " + p);

    if ((message.getMessage()[1] & 0xFF) < 12) {
      costumes_programs[ch - 1][(message.getMessage()[1] & 0xFF) + 2] = byte(p);
    } else {
      last_midi_message = millis();
      costumes_programs[ch - 1][0] = byte(c);
      costumes_programs[ch - 1][1] = byte(p);
    }
    if (midi_console) {
      print("Constant programs: ");
      for (byte z = 2; z < 14; z++) {
        print(" [" + costumes_programs[ch - 1][z] + "] ");
      }
      println();
    }
    midi_program_millis[ch - 1] = millis() + mesh_millis_offset;
    
  } else if (message.getStatus() > 207 && message.getStatus() < 224) {  //// Обратная совместимость
    println("2nd parameter: "+(byte)(message.getMessage()[1] & 0xFF));

    for (byte i = 0; i < 16; i++) {
      costumes_programs[i][2] = (byte)(message.getMessage()[1] & 0xFF);
    }

    /*
    for (int i=0; i<256; i++) {
     JSONArray index = ctrl.getJSONArray(i);
     costumes_data[i][6] = (byte)(message.getMessage()[1] & 0xFF);
     }
     */
  }
}
