import themidibus.*;
import javax.sound.midi.MidiMessage;
MidiBus myBus; // The MidiBus

import controlP5.*;
import java.util.*;
ControlP5 cp5;

import hypermedia.net.*;
UDP udp;
UDP answer;

// long last_send;

int c;
int costumes_online;

JSONArray ctrl;
byte channel_to_control;
int costume_to_control;

PFont f;

void settings() {
  pixelDensity(displayDensity());
  //  size(940, 25, P2D);
  size(size_x, size_y);
}

void setup() {
  surface.setTitle("Svetlitsa MIDI bridge");
  surface.setResizable(true);
  frameRate(50);
  background(#f0f0f0);

  ctrl = loadJSONArray("costumes.json");

  println(MidiBus.availableInputs());

  //udp.setBuffer(16777216);

  myBus = new MidiBus(this, 1, -1); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
  udp = new UDP( this, 12321);//, "239.0.0.13" );
  answer = new UDP( this, 6000, "224.0.0.1" );
  answer.listen( true );

  f = createFont("OpenSans-Regular.ttf", 14, true);
  textFont(f);
}

void draw() {
  if (costumes_online != c) {
    screen_size(c);
  }

  background(#f0f0f0);
  fill(0);
  text("Svetlitsa", 15, 15);
  text("№", 15, 35);
  text("Costume", 40, 35);
  text("Status", 210, 35);
  text("Ping", 270, 35);
  text("Bat, %", 330, 35);
  text("Volt", 380, 35);
  text("Ch", 430, 35);
  text("P", 465, 35);
  text("2", 500, 35);
  text("ip", 535, 35);
  text("Channel picker", control_table_x, 35);
  
  text(millis(), 700, 15);

  // debug
  // text(mouseX + " " + mouseY, 100, 15);

  list_costumes();
}


void screen_size(int num) {
  costumes_online = c;
  surface.setSize(950, num * 20 + 25);
}
