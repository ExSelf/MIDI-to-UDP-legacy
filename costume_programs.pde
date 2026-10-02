// What is supposed to happen
int[]   program_millis = new int[256];
byte[][] costumes_programs = new byte[256][14];

// Что фактически
byte[][] costumes_data =    new byte[256][14];
int[]    costumes_voltage = new int[256];
String[] costumes_ip =      new String[256];
int[]    costumes_millis =  new int[256];
int[]    costumes_program_millis =  new int[256];
byte[] costumes_charge = new byte[256];


void receive( byte[] data, String costume_ip, int port ) {
//  println(data);

  if (data.length == 21) {
    costumes_millis[data[0]-1] = millis();

    costumes_ip[data[0]-1] = costume_ip;
    int voltage;
    voltage = int(data[6] << 8) + int(data[5]);
    costumes_voltage[data[0]-1] = voltage;

    int m = int(data[4] << 24) + int(data[3] << 16) + int(data[2] << 8) + int(data[1]);
    costumes_program_millis[data[0]-1] = m & 0xFFFF;

    for (byte d = 0; d < 14; d++) {
      costumes_data[data[0]-1][d] = data[7 + d];
      
      if(costumes_data[data[0]-1][d] != 0 && costumes_programs[data[0]-1][d] == 0) {
        costumes_programs[data[0]-1][d] = costumes_data[data[0]-1][d];
      }
    }
  } else if (data.length == 22) {
    costumes_millis[data[0]-1] = millis();

    costumes_ip[data[0]-1] = costume_ip;
    int voltage;
    voltage = int(data[6] << 8) + int(data[5]);
    costumes_voltage[data[0]-1] = voltage;
    
    byte charge = data[21];
    costumes_charge[data[0]-1] = charge;

    int m = int(data[4] << 24) + int(data[3] << 16) + int(data[2] << 8) + int(data[1]);
    costumes_program_millis[data[0]-1] = m & 0xFFFF;

    for (byte d = 0; d < 14; d++) {
      costumes_data[data[0]-1][d] = data[7 + d];
      
      if(costumes_data[data[0]-1][d] != 0 && costumes_programs[data[0]-1][d] == 0) {
        costumes_programs[data[0]-1][d] = costumes_data[data[0]-1][d];
      }
    }
  }
}
