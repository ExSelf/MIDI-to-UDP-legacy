int last_midi_message;

void midiMessage(MidiMessage message) { // You can also use midiMessage(MidiMessage message, long timestamp, String bus_name)
  if (message.getStatus() > 143 && message.getStatus() < 160) {
      last_midi_message = millis();
    
    int ch = message.getStatus() - 143;
    int com = (byte)(message.getMessage()[1] & 0xFF);
    int par = (byte)(message.getMessage()[2] & 0xFF);

    boolean d = true;
    if (d) {
      println();
      println("Channel: " + ch);
      println("Command: " + com);
      println("Parameter: " + par);
    }

    for (int i=0; i<256; i++) {
      JSONArray index = ctrl.getJSONArray(i);
      boolean is_reacting = index.getBoolean(message.getStatus() - 143);
      if (is_reacting) {
        if (com < 12) {
          costumes_programs[i][com] = (byte)par;
        } else {
          costumes_programs[i][12] = (byte)com;
          costumes_programs[i][13] = (byte)par;
          program_millis[i] = millis();
        }
      }


      // debug
      // print(program_millis[ch - 1] + " - ");
      // println(costumes_programs[ch - 1]);
    }

  } else if (message.getStatus() > 207 && message.getStatus() < 224) {
      println("2nd parameter: "+(byte)(message.getMessage()[1] & 0xFF));
      for (int i=0; i<256; i++) {
        JSONArray index = ctrl.getJSONArray(i);
        costumes_programs[i][0] = (byte)(message.getMessage()[1] & 0xFF);
      }
    }

}
