void list_costumes() {
  if (millis() - last_midi_message < 75) {
    fill(128, 255, 0);
  } else {
    fill(#f0f0f0);
  }
  circle(142, 78, 10);

  fill(0);
  text("№", const_first_x, const_first_y);
  text("Костюм", const_first_x + const_num_x, const_first_y);
  text("Статус", const_first_x + const_num_x + const_name_x, const_first_y);
  if (reply) {
    text("Отклик", const_first_x + const_num_x + const_name_x + const_status_x, const_first_y);
  }
  text("Напряжение", const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply), const_first_y);
  if (commands) {
    text("К", const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x, const_first_y);
  }
  if (ip_address) {
    text("ip адрес", const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands), const_first_y);
  }
  if (channels) {
    text("Управление c канала", const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address), const_first_y);
  }

  int g_m = millis() + mesh_millis_offset;
  int h = g_m / 3600000;
  int m = (g_m / 60000) % 60;
  char zero_m;
  char zero_s;
  if (m < 10) {
    zero_m = '0';
  }
  if (((g_m / 1000) - m * 60) < 10) {
    zero_s = '0';
  }
  text( h + ":" + m + ":" + ((g_m / 1000) - m * 60 - h * 3600) + "." + g_m % 1000, 570, 30);

  costumes_to_list = 1;

  for (int i = 0; i < 256; i++) {
    JSONArray index = ctrl.getJSONArray(i);
    int offline_time = millis() + mesh_millis_offset - costumes_millis[i];
    if (costumes_millis[i] > 0 && offline_time < offline_period * 30) {

      if ((costumes_to_list % 2) == 1) {
        fill(200, 200, 200);
        rect(0, const_first_y + 5 + ((costumes_to_list - 1) * 20), size_x + 15, 20);
      }

      fill(0);
      text(costumes_to_list + ".", const_first_x, const_first_y + (costumes_to_list * 20));

      // Цвет имени костюма
      if (costumes_millis[i] + 10000 < g_m) {
        fill(128, 128, 0);
      }

      text(index.getString(0), const_first_x + const_num_x, const_first_y + (costumes_to_list*20));

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
      circle(const_first_x + const_num_x + const_name_x + 20, const_first_y - 5 + (costumes_to_list * 20), 15);

      // Время отклика
      fill(0);
      if (offline_time < 1000) {
        text("< 1 сек", const_first_x + const_num_x + const_name_x + const_status_x, const_first_y + (costumes_to_list * 20));
      } else {
        text(offline_time / 1000 + " сек", const_first_x + const_num_x + const_name_x + const_status_x, const_first_y + (costumes_to_list * 20));
      }

      // Цвет напряжения
      if (costumes_voltage[i]<10000) {
        fill(255, 16, 0);
      } else if (costumes_voltage[i] < 11000) {
        fill(255, 128, 0);
      } else {
        fill(0, 192, 0);
      }

      // Напряжение
      String volt = "";
      if (costumes_voltage[i] < 10000) volt += "  ";
      volt += costumes_voltage[i]/1000 + ".";
      if (costumes_voltage[i] % 1000 / 10 < 10) volt += "0";
      volt += costumes_voltage[i]%1000/10 + " В";

      text(volt, const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply), const_first_y + (costumes_to_list * 20));

      // Цвет программы

      int highest_program_mills = 0;
      byte right_program_n = 0;
      for (byte ch = 1; ch < 17; ch++) {
        boolean is_reacting = index.getBoolean(ch);
        if (is_reacting && highest_program_mills < midi_program_millis[ch - 1]) {
          highest_program_mills = midi_program_millis[ch - 1];
          right_program_n = ch;
        }
      }

      // Программа

      if (right_program_n == 0 || highest_program_mills == costumes_program_mills[i]) {
        fill(0, 192, 0);
        text((costumes_recieved_programs[i][0] & 0xFF), const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x, const_first_y + (costumes_to_list * 20));
      } else {
        fill(192, 0, 0);
        if (right_program_n != 0) {
          text((costumes_recieved_programs[i][0] & 0xFF) + " (" + (costumes_programs[right_program_n - 1][0] & 0xFF) + ")", const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x - 10, const_first_y + (costumes_to_list * 20));
          if (millis() - last_send[i] > send_interval) {
            last_send[i] = millis();
            sendPacket(0, (i + 1), (right_program_n - 1));
          }
        }
      }

      if (channels) {
        // отображение прослушиваемых каналов
        for (byte ch = 1; ch < 18; ch++) {
          boolean is_reacting = index.getBoolean(ch);
          if (is_reacting) {
            fill(#000000);
          } else {
            if ((costumes_to_list % 2) == 1) {
              fill(#f0f0f0);
            } else {
              fill(#cccccc);
            }
          }
          if (ch < 10) {
            text(ch, const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address) - 15 + ch*15, const_first_y + (costumes_to_list * 20));
          } else if (ch < 17) {
            text(ch, const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address) - 65 + ch*20, const_first_y + (costumes_to_list * 20));
          } else {
            text("t", const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address) - 65 + ch*20, const_first_y + (costumes_to_list * 20));
          }
        }
      }

      if (ota) {
        fill(0);
        text("OTA", const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address) - 15 + const_channels_x * int(channels), const_first_y + (costumes_to_list * 20));
      }


      // управление
      if (mouseY > const_first_y + ((costumes_to_list - 1) * 20) && mouseY < const_first_y + 20 + ((costumes_to_list - 1) * 20)) {
        costume_to_control = i;

        if (channels) {
          // смена канала
          if (mouseX < const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address) + 135) {
            channel_to_control = byte((mouseX - (const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address)) + 15) / 15);
          } else {
            channel_to_control = byte((mouseX - (const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address)) + 65) / 20);
          }
        }
        /*
          print(costume_to_control);
         print(" - ");
         println(channel_to_control);
         */
      }

      costumes_to_list++;
    }
  }
}

void screen_size(int num) {
  costumes_online = costumes_to_list;
  surface.setSize(const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address) + const_channels_x * int(channels) + const_ota_x * int(ota), num * 20 + const_first_y - 15);
}
