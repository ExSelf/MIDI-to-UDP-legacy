void list_costumes() {  
  if (millis() - last_midi_message < 75) {
    fill(128, 255, 0);
  } else {
    fill(#f0f0f0);
  }
  circle(90, 11, 10);
  
    if (millis() - send_time < 75) {
    fill(128, 255, 0);
  } else {
    fill(#f0f0f0);
  }
  circle(435, 11, 10);


  c = 1;

  for (int i = 0; i < 256; i++) {
    JSONArray index = ctrl.getJSONArray(i);

    long offline_time = millis() - costumes_millis[i];// & 0xFFFF;
    if (costumes_millis[i] > 0 && offline_time < offline_period * 30) {

      fill(0);

      // Порядковый номер
      text(c + ".", 15, 35 + (c*20));

      // Название костюма
      if (editing && i == costume_to_control) {
        text(name + "_", 40, 35 + (c*20));
      } else {
        text(index.getString(0), 40, 35 + (c*20));
      }

      // Цвет кружка статуса
      int status_r;
      int status_g;
      if (offline_time < offline_period / 2) {
        status_r = int(offline_time * 510 / offline_period);
        status_g = 255;
      } else if (offline_time < offline_period) {
        status_r = 255;
        status_g = int(255 - (offline_time - offline_period / 2) * 510/ offline_period);
      } else {
        status_r = 255;
        status_g = 0;
      }
      fill(status_r, status_g, 0);

      // Кружок статуса
      circle(235, 30 + (c*20), 15);

      // Время отклика
      fill(0);
      if (offline_time < 1000) {
        text("< 1 сек", 270, 35 + (c*20));
      } else {
        text(offline_time / 1000 + " сек", 270, 35 + (c*20));
      }

      // Charge color
      if (costumes_charge[i] < 35) {
        fill(255, 16, 0);
      } else if (costumes_charge[i] < 70) {
        fill(255, 128, 0);
      } else {
        fill(0, 192, 0);
      }


      // Charge
      String charge = "";
      if (costumes_charge[i] < 100) charge += " ";
      charge += costumes_charge[i];

      text(charge, 330, 35 + (c*20));


      int v = constrain(costumes_charge[i], 9000, 12600);
      if (v > 10800) {
        status_r = (12600 - v) * 255 / 1800;
        status_g = 255;
      } else {
        status_r = 255;
        status_g = (v - 9000) * 255 / 1800;
      }
      float voltage_percent = round(map(v, 9000, 12600, 0, 100));
      voltage_percent = voltage_percent /100;
      
      // Voltage
            fill(0);
                  String voltage = "";
      if (costumes_voltage[i] < 1000) charge += " ";
      voltage += costumes_voltage[i];

      text(voltage, 380, 35 + (c*20));
            
      /*
      byte newest_program_channel = 0;
       int highest_millis = 0;
       for (byte ch = 1; ch < 17; ch++) {
       boolean is_reacting = index.getBoolean(ch);
       if ((is_reacting) && ((program_millis[ch - 1] & 0xFFFF) > highest_millis)) {
       highest_millis = int(program_millis[ch - 1]) & 0xFFFF;
       newest_program_channel = ch;
       //println(highest_millis);
       }
       }
       
       boolean d = false;
       if (d) {
       if (newest_program_channel > 0) print(millis() + " - " + costumes_program_millis[i] + " - " + program_millis[newest_program_channel-1]);
       if (costumes_program_millis[i] ==  highest_millis) println(" - equal");
       else println(" - not equal");
       }
       if (newest_program_channel == 0) {
       fill(0, 192, 0);
       } else if (highest_millis == 0 || highest_millis == costumes_program_millis[i]) {
       fill(0, 192, 0);
       } else {
       fill(192, 0, 0);
       }
       */
      // Цвет программы


      if (Arrays.equals(costumes_data[i], costumes_programs[i])) {
        //if (costumes_data[i] == costumes_programs[i]) {
        fill(0, 192, 0);
      } else {
        fill(192, 0, 0);
      }

      /* debug
       for (byte pr = 0; pr < 14; pr++) {
       text(costumes_data[i][pr], 430 + 20*pr, 15);
       text(costumes_programs[i][pr], 430 + 20*pr, 35);
       }
       */
      // Программа
      if (Arrays.equals(costumes_data[i], costumes_programs[i]) && (program_millis[i] & 0xFFFF)  == (costumes_program_millis[i] & 0xFFFF)) {
        text(costumes_data[i][12] & 0xFF, 430, 35 + (c*20));
      } else {
        text((costumes_data[i][12] & 0xFF) + " (" + costumes_programs[i][12] + ")", 415, 35 + (c*20));
        if (offline_time < offline_period) {
          send(i);//, newest_program_channel);
        }
      }
      // Цвет параметра
      /*
            if (costumes_data[i][5] == costumes_programs[i][1]) {
       fill(0, 192, 0);
       } else {
       fill(192, 0, 0);
       }
       */

      // Параметр
      text(costumes_data[i][13] & 0xFF, 465, 35 + (c*20));

      // Цвет 2го параметра
      /*
            if (costumes_data[i][5] == costumes_programs[i][1]) {
       fill(0, 192, 0);
       } else {
       fill(192, 0, 0);
       }
       */

      // 2й параметр
      text(costumes_data[i][0] & 0xFF, 500, 35 + (c*20));

      // ip адрес
      fill(0, 0, 0);
      text(costumes_ip[i], 535, 35 + (c*20));

      // отображение прослушиваемых каналов
      for (byte ch = 1; ch < 18; ch++) {
        boolean is_reacting = index.getBoolean(ch);
        if (is_reacting) {
          fill(#000000);
        } else {
          fill(#bbbbbb);
        }
        if (ch < 10) {
          text(ch, control_table_x - 15 + ch*15, 35 + (c*20));
        } else if (ch < 17) {
          text(ch, control_table_x - 65 + ch*20, 35 + (c*20));
        } else {
          text("t", control_table_x - 65 + ch*20, 35 + (c*20));
        }
      }

      // управление
      if (mouseY > 15 + (c*20) && mouseY < 35 + (c*20)) {
        costume_to_control = i;

        // смена имени
        if ((mouseX > 40) && (mouseX < 210)) {
        }

        // смена канала
        if (mouseX < control_table_x + 135) {
          channel_to_control = byte((mouseX - control_table_x + 15) / 15);
        } else {
          channel_to_control = byte((mouseX - control_table_x + 65) / 20);
        }
      }
      /*
      if (offline_time < 5000) {
       send(i);
       }
       */
      c++;
    }
  }
}
