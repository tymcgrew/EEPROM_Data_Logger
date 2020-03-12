const int s_data = 4;
const int s_clk = 5;
const int delay_time = 1;

void setup() {
  pinMode(s_clk, OUTPUT);
  pinMode(s_data, INPUT);
  Serial.begin(9600);
}

void loop() {
  for (int i = 2048; i < (2048)+(3*64); i += 64)
  {
    //page_write(i,0);
    page_read(i);
  }
  while(true);
}

void page_read(int start_address) {
  set_address(start_address);
  
  // Control Byte
  start();
  write_high();
  write_low();
  write_high();
  write_low();
  write_low();
  write_low();
  write_low();
  write_high(); 
  int ack = check_ack();   
  //Serial.println(ack);

  for (int i = 0; i < 63; i++)
  {
    int val = 0;
    val += read_bit()*1;
    val += read_bit()*2;
    val += read_bit()*4;
    val += read_bit()*8;
    val += read_bit()*16;
    val += read_bit()*32;
    val += read_bit()*64;
    val += read_bit()*128;
    Serial.println(val);
    write_low();  
  }

    int val = 0;
    val += read_bit()*1;
    val += read_bit()*2;
    val += read_bit()*4;
    val += read_bit()*8;
    val += read_bit()*16;
    val += read_bit()*32;
    val += read_bit()*64;
    val += read_bit()*128;
    Serial.println(val);
    stop1();  

}

void page_write(int start_address, int write_value) {
  // Find binary address
  int start_address_binary [15] = {0};
  int i1 = 0; 
  while (start_address > 0) { 
      start_address_binary[i1] = start_address % 2; 
      start_address = start_address / 2; 
      i1++; 
    }

  // Find binary write_value
  int write_value_binary [8] = {0};
  int i2 = 0; 
  while (write_value > 0) { 
      write_value_binary[i2] = write_value % 2; 
      write_value = write_value / 2; 
      i2++; 
    }

    start();
    write_high();
    write_low();
    write_high();
    write_low();
    write_low();
    write_low();
    write_low();
    write_low();
    int ack = check_ack();
    //Serial.println(ack);

    // Address High Byte
    write_low();
    for (int j = 14; j >= 8; j--) {
      if (start_address_binary[j] == 1)
        write_high();
      else
        write_low();
    }
    ack = check_ack();
    //Serial.println(ack);
  
    // Address Low Byte
    for (int j = 7; j >= 0; j--) {
      if (start_address_binary[j] == 1)
        write_high();
      else
        write_low();
    }
    ack = check_ack();
    //Serial.println(ack);

    for (int i = 0; i < 63; i++)
    {
      // Write Byte
      for (int j = 0; j < 8; j++) {
        if (write_value_binary[j] == 1)
          write_high();
        else
          write_low();
      }
      ack = check_ack();
      //Serial.println(ack);
    }
    
    // Write Byte
    for (int j = 0; j < 8; j++) {
      if (write_value_binary[j] == 1)
        write_high();
      else
        write_low();
    }
    ack = check_ack();
    //Serial.println(ack);
    stop1();
  
}

void set_address(int start_address) {
  // Find binary address
  int start_address_binary [15] = {0};
  int i = 0; 
  while (start_address > 0) { 
      start_address_binary[i] = start_address % 2; 
      start_address = start_address / 2; 
      i++; 
    }

  // Control Byte
  start();
  write_high();
  write_low();
  write_high();
  write_low();
  write_low();
  write_low();
  write_low();
  write_low(); 
  int ack = check_ack(); 
  //Serial.println(ack);

  // Address High Byte
  write_low();
  for (int i = 14; i >= 8; i--) {
    if (start_address_binary[i])
      write_high();
    else
      write_low();
  }
  ack = check_ack();
  //Serial.println(ack);

  // Address Low Byte
  for (int i = 7; i >= 0; i--) {
    if (start_address_binary[i])
      write_high();
    else
      write_low();
  }
  ack = check_ack();
  //Serial.println(ack);

}

int read_bit() {
  digitalWrite(s_clk, HIGH);
  delay(delay_time);
  int val = digitalRead(s_data);
  digitalWrite(s_clk, LOW);
  delay(delay_time);
  return val;
}

void start() {
  digitalWrite(s_data,HIGH);
  pinMode(s_data,OUTPUT);
  delay(delay_time);
  digitalWrite(s_clk, HIGH);
  delay(delay_time);
  digitalWrite(s_data,LOW);
  delay(delay_time);
  digitalWrite(s_clk,LOW);
  pinMode(s_data,INPUT);
  delay(delay_time);
}

void write_high() {
  digitalWrite(s_data,HIGH);
  pinMode(s_data,OUTPUT);
  delay(delay_time);
  digitalWrite(s_clk,HIGH);
  delay(delay_time);
  digitalWrite(s_clk,LOW);
  pinMode(s_data,INPUT);
  delay(delay_time);  
}

void write_low() {
  digitalWrite(s_data,LOW);
  pinMode(s_data,OUTPUT);
  delay(delay_time);
  digitalWrite(s_clk,HIGH);
  delay(delay_time);
  digitalWrite(s_clk,LOW);
  pinMode(s_data,INPUT);
  delay(delay_time);  
}

int check_ack() {
  digitalWrite(s_clk,HIGH);
  delay(delay_time);
  int ack = digitalRead(s_data);
  digitalWrite(s_clk,LOW);
  delay(delay_time);
  return ack;
}

void stop1(){
  digitalWrite(s_data,LOW);
  pinMode(s_data,OUTPUT);
  delay(delay_time);
  digitalWrite(s_clk, HIGH);
  delay(delay_time);
  digitalWrite(s_data,HIGH);
  delay(delay_time);
  digitalWrite(s_clk,LOW);
  delay(delay_time);
  pinMode(s_data,INPUT);
  delay(delay_time);
}



