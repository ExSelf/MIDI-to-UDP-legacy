int speed = 115211;
int offline_period = 10000;

String portName;     // имя порта

import processing.serial.*;
Serial serial;

import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; 
MidiBus myBus; // The MidiBus

PFont f;

import controlP5.*;
ControlP5 cp5;
byte skip = 1;

JSONArray ctrl;

byte channel_to_control;
int mesh_millis_offset;
int costumes_to_list;
int costumes_online;
int costume_to_control;
int g_m;

void settings() {
  pixelDensity(displayDensity());
  size(size_x, size_y);
}

void setup() {
  MidiBus.list();
  frameRate(250);

  myBus = new MidiBus(this, 1, -1);
  println("Using 0 output");

  surface.setTitle("Svetlitsa MIDI bridge");
  surface.setResizable(true);
  setupGUI();        // инициализация интерфейса

  ctrl = loadJSONArray("costumes.json");
  
    f = createFont("OpenSans-Regular.ttf", 14, true);
  textFont(f);
}

void picker(int col) {
  String str = str(int(red(col))) + ',';
  str += str(int(green(col))) + ',';
  str += str(int(blue(col)));
  //  sendPacket(1, str);
}

void draw() {
  background(#f0f0f0);   // заливаем фон
  parsing();             // парсим
  
  g_m = millis() + mesh_millis_offset;

  if (costumes_online != costumes_to_list) {
    screen_size(costumes_to_list);
  }

  com_and_midi_ports();

  list_costumes();

  if (mouseX > (const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address)) &&
    mouseX < (const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address) + const_channels_x * int(channels) + const_ota_x * int(ota)) &&
    mouseY > const_first_y &&
    mouseY < const_first_y + ((costumes_to_list - 1) * 20)) {
    cursor(HAND);
  } else {
    cursor(ARROW);
  }
}


// функция для отправки пакета на арду
void sendPacket(int key, int num, int prog) {
  if (serial != null) {
    serial.write(
      str(key) + ','
      + str(TTL) + ','
      + str(num) + ','
      + str( g_m        & 255) + ','
      + str( g_m  >>  8 & 255) + ','
      + str( g_m  >> 16 & 255) + ','    
      + str( g_m  >> 24 & 255) + ','
      + str( midi_program_millis[prog]            & 255) + ','
      + str((midi_program_millis[prog])     >>  8 & 255) + ','
      + str((midi_program_millis[prog])     >> 16 & 255) + ','
      + str((midi_program_millis[prog])     >> 24 & 255) + ','
      + str(costumes_programs[prog][0]) + ','
      + str(costumes_programs[prog][1]) + ','
      + str(costumes_programs[prog][2]) + ','
      + str(costumes_programs[prog][3]) + ','
      + str(costumes_programs[prog][4]) + ','
      + str(costumes_programs[prog][5]) + ','
      + str(costumes_programs[prog][6]) + ','
      + str(costumes_programs[prog][7]) + ','
      + str(costumes_programs[prog][8]) + ','
      + str(costumes_programs[prog][9]) + ','
      + str(costumes_programs[prog][10]) + ','
      + str(costumes_programs[prog][11]) + ','
      + str(costumes_programs[prog][12]) + ','
      + str(costumes_programs[prog][13]) + ';');
  }
  if (console) {
    println(
      str(key) + ','
      + str(TTL) + ','
      + str(num) + ','   
      + str(g_m) + ','
      + str(midi_program_millis[prog]) + ','
      + str(costumes_programs[prog][0]) + ','
      + str(costumes_programs[prog][1]) + ','
      + str(costumes_programs[prog][2]) + ','
      + str(costumes_programs[prog][3]) + ','
      + str(costumes_programs[prog][4]) + ','
      + str(costumes_programs[prog][5]) + ','
      + str(costumes_programs[prog][6]) + ','
      + str(costumes_programs[prog][7]) + ','
      + str(costumes_programs[prog][8]) + ','
      + str(costumes_programs[prog][9]) + ','
      + str(costumes_programs[prog][10]) + ','
      + str(costumes_programs[prog][11]) + ','
      + str(costumes_programs[prog][12]) + ','
      + str(costumes_programs[prog][13]) + ';');
  }
}
