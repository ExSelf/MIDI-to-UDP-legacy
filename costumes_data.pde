//String[] costumes_name = new String[256];
int[] costumes_voltage = new int[256];
int[] costumes_millis = new int[256];                     // received global timestamp
int[] costumes_program_mills = new int[256];              // received program timestamp
byte[][] costumes_recieved_programs = new byte[256][14];

int[] midi_program_millis = new int[16];
byte[][] costumes_programs = new byte[16][14];

int[] last_send = new int[256];


// функция парсинга, опрашивать в лупе
void parsing() {
  // если порт открыт и в буфере что то есть
  if (serial != null && serial.available() > 0) {

    String str = serial.readStringUntil('\n');//.trim();  // читаем строку до \n и подрезаем
    if (str != null && str.length() > 25 && str.length() < 100) {
      //      println(str.length());
      int[] data = int(split(str, ','));
      //      println(data.length);
      //      println(data); //54,260142,947,13,111,0,0,0,0,0,0,0,0,0,0,0,0,192835

      if (skip < 5) {
        skip++;
        return;  // пропускаем первый пакет
      }

      if (data.length == 20) {

        if (data[1] > millis() + mesh_millis_offset - 50) {
          mesh_millis_offset = data[1] - millis();
        }

        costumes_millis[data[0] - 1] = millis() + mesh_millis_offset;

        costumes_program_mills[data[0] - 1] = data[17];

        costumes_voltage[data[0] - 1] = data[2];

        for (byte p = 0; p < 14; p++) {
          costumes_recieved_programs[data[0] - 1][p] = byte(data[p + 3]);
        }

        JSONArray index = ctrl.getJSONArray(data[0] - 1);

        for (byte d = 0; d < 16; d++) {
          boolean is_reacting = index.getBoolean(d + 1);
          if (is_reacting &&
            costumes_programs[d][0] == 0 &&
            costumes_programs[d][1] == 0 &&
            costumes_programs[d][2] == 0 &&
            costumes_programs[d][3] == 0 &&
            costumes_programs[d][4] == 0 &&
            costumes_programs[d][5] == 0 &&
            costumes_programs[d][6] == 0 &&
            costumes_programs[d][7] == 0 &&
            costumes_programs[d][8] == 0 &&
            costumes_programs[d][9] == 0 &&
            costumes_programs[d][10] == 0 &&
            costumes_programs[d][11] == 0 &&
            costumes_programs[d][12] == 0 &&
            costumes_programs[d][13] == 0) {
            for (byte z = 0; z < 14; z++) {
              costumes_programs[d][z] = costumes_recieved_programs[data[0] - 1][z];
            }
          }
        }

        if (console) {
          print ("Got from ");
          print (data[0]);
          print (", TTL=");
          print (data[18]);
          print (" at global time ");
          print (data[1]);
          print (", voltage ");
          print (data[2]);
          print (", command ");
          print (data[3]);
          print (", sent at ");
          println(costumes_program_mills[data[0] - 1]);
        }
      }
    }
  }
}
