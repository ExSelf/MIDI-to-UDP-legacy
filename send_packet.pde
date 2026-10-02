long send_time;

void send(int i) {//, int ch) {
  byte[] message =    new byte[22];
  //  byte[] message =  costumes_programs[ch];
  send_time = millis();

  message[ 0] = byte( program_millis[i]        & 255);
  message[ 1] = byte((program_millis[i] >>  8) & 255);
  message[ 2] = byte((program_millis[i] >> 16) & 255);
  message[ 3] = byte((program_millis[i] >> 24) & 255);

  message[ 4] = byte( send_time        & 255);
  message[ 5] = byte((send_time >>  8) & 255);
  message[ 6] = byte((send_time >> 16) & 255);
  message[ 7] = byte((send_time >> 24) & 255);

  for (byte c = 0; c < 14; c++) {
    message[c + 8] = costumes_programs[i][c];
  }

//  println(ch + " - " + costumes_ip[i] + " - "  + message);



  if (costumes_ip[i].length() > 0) {
    udp.send(message, costumes_ip[i]);
  }
}
