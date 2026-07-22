// Constants
int size_y = 700;
int const_first_x = 15;
int const_num_x = 25;
int const_name_x = 170;
int const_status_x = 60;
int const_reply_x = 60;
int const_voltage_x = 100;
int const_commands_x = 35;
int const_ip_address_x = 115;
int const_channels_x = 300;
int const_ota_x = 15;

int const_first_y = 115;

int send_interval = 100;

// Variables
boolean reply = true;
boolean commands = true;
boolean ip_address = false;
boolean channels = true;
boolean send_enable = true;
boolean ota = true;
boolean console;
boolean open_com;
boolean midi_console;
int TTL;

int size_x = const_first_x + const_num_x + const_name_x + const_status_x + const_reply_x * int(reply) + const_voltage_x + const_commands_x * int(commands) + const_ip_address_x * int(ip_address) + const_channels_x * int(channels);
