
// ======= ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА ========
void setupGUI() {
  cp5 = new ControlP5(this);
  cp5.setFont(createFont("Arial", 8 / displayDensity()));  // сделаем шрифт побольше

  // добавляем кнопки
  //  cp5.addButton("open").setPosition(260, 10).setSize(80, 30);
  //  cp5.addButton("close").setPosition(340, 10).setSize(80, 30).linebreak();

  // тогглы
  cp5.addToggle("console")
    .setValue(false)
    .setPosition(10, 50)
    .setColorLabel(0x000000);

  cp5.addToggle("channels")
    .setValue(true)
    .setPosition(60, 50)
    .setColorLabel(0x000000);

  cp5.addToggle("midi_console")
    .setLabel("MIDI")
    .setValue(false)
    .setPosition(110, 50)
    .setColorLabel(0x000000); 

  cp5.addToggle("open_com")
    .setLabel("open")
    .setPosition(270, 10)
    .setSize(60, 30)
    .setValue(false)
    .setColorLabel(0x000000);

  // выпадающий список
  cp5.addScrollableList("com")
    .setPosition(10, 10)
    .setSize(250, 500)
    .setBarHeight(30)
    .setItemHeight(30)
    .close()
    .addItems(Serial.list());
  ;

  cp5.addSlider("TTL")
//    .setLabel("ttl")
    .setPosition(340, 10)
    .setColorLabel(0) 
    .setWidth(100)
    .setHeight(30) 
    .setRange(0, 7) // values can range from big to small as well
    .setValue(1)
    .setNumberOfTickMarks(7)
    .setSliderMode(Slider.FLEXIBLE)
    ;
}



//  cp5.addToggle("fan").setMode(ControlP5.SWITCH);
//  cp5.addToggle("bulb").setMode(ControlP5.SWITCH);

/*  cp5.addColorWheel("picker", 10, 110, 100);
 
 myChart = cp5.addChart("light")
 .setPosition(280, 140)
 .setSize(200, 80)
 .setRange(0, 1023)
 .setView(Chart.LINE)
 .addDataSet("incoming")
 .setData("incoming", new float[100]);
 ;
 
 cp5.addSlider("temp")
 .setPosition(120, 110)
 .setSize(20, 100)
 .setRange(20, 40)
 ;
 cp5.addKnob("knob").setRange(0, 180).setRadius(30).setPosition(180, 130);
 
 
 cp5.addTextfield("input").setPosition(160, 60).setSize(100, 20);
 cp5.addButton("send").setPosition(160, 80).setSize(100, 20);
 // meter
 m = new Meter(this, 280, 10);
 m.setMeterWidth(200);
 m.setUp(0, 1023, 0, 100, -180, 0);
 String[] scaleLabels = {"0", "20", "40", "60", "80", "100"};
 m.setScaleLabels(scaleLabels);
 */

// ==== ОБРАБОТЧИКИ ИНТЕРФЕЙСА =====
// список портов
void com(int n) {
  portName = Serial.list()[n];  // запоминаем выбранный порт в portName
}

// кнопка открыть порт
void open() {
  if (portName != null && serial == null) {     // если выбран порт и сейчас он закрыт
    serial = new Serial(this, portName, speed); // открываем portName
    skip = 1;    // флаг на пропуск первого пакета
  }
}

// кнопка закрыть порт
void close() {
  if (serial != null) { // если порт открыт
    serial.stop();      // закрываем portName
    serial = null;      // serial выключен
  }
}

void com_and_midi_ports() {
  if (open_com) {
    if (portName != null && serial == null) {     // если выбран порт и сейчас он закрыт
      serial = new Serial(this, portName, speed); // открываем portName
      skip = 1;    // флаг на пропуск первого пакета
    }
  } else {
    if (serial != null) { // если порт открыт
      serial.stop();      // закрываем portName
      serial = null;      // serial выключен
    }
  }
}

void dropdown(int n) {
  /* request the selected item based on index n */
  println(n, cp5.get(ScrollableList.class, "dropdown").getItem(n));

  /* here an item is stored as a Map  with the following key-value pairs:
   * name, the given name of the item
   * text, the given text of the item by default the same as name
   * value, the given value of the item, can be changed by using .getItem(n).put("value", "abc"); a value here is of type Object therefore can be anything
   * color, the given color of the item, how to change, see below
   * view, a customizable view, is of type CDrawable
   */

  CColor c = new CColor();
  c.setBackground(color(255, 0, 0));
  cp5.get(ScrollableList.class, "dropdown").getItem(n).put("color", c);
}
