#include <alcd.h>
#include <delay.h>
#include <mega16.h>
#include <stdint.h>
#include <stdlib.h>
#include <eeprom.h>
#include <string.h>

// states
#define IDLE -1
#define INIT 0
#define LOGIN_USER 1
#define LOGIN_PASS_INIT 2
#define LOGIN_PASS 3
#define LOGIN_CHECK 4
#define LOGIN_ERROR 5
#define USER_LOGGED 6
#define GUEST_LOGGED 7
#define ADMIN_MENU 8
#define ADMIN_CHECK 9
#define ADMIN_ADD 10
#define ADMIN_ADD_ID 11
#define ADMIN_ADD_PASS_INIT 12
#define ADMIN_ADD_PASS 13
#define ADMIN_DEL 14
#define ADMIN_DEL_CHECK 15
#define ADMIN_CNT 16
#define ADMIN_CNT_CHECK 17
#define DOOR_OPEN 18

// constants
const int MAX_USER = 10;


// structs
typedef struct {
  char id[4];
  char password[4];
} User;

// variables
char ADMIN_PASS[4];
char ADMIN_ID[4];
char GUEST_ID[4];
char GUEST_PASS[4];


int state = 0;
int cursor = 0;
int access = 2;
int EEMEM eaccess = 0;
int freeUserIndex = -1;


User currentUser;
User users[MAX_USER];
User EEMEM eusers[MAX_USER];

// functions

int isValid(char* A){
  int i;
  for (i = 0; i < 4; i++) {
    if (((int) A[i]) >= '0' || ((int) A[i]) <= '9' );
    else return 0;
  }
  return 1;
}
void move(char* A,char* B){
  int i;
  for (i = 0; i<4; i++)
    A[i] = B[i];
}
int equals(char* A,char* B){
  int i;
  for (i = 0; i<4; i++) {
    if (A[i] == B[i]);
    else {
      delay_ms(1000);
      return 0;
    }
  }
  return 1;
}

void loadData() {
  int i;
  // load users

  for ( i = 0 ;i < MAX_USER ; i++) {
    eeprom_read_block(&users[i], &eusers[i], sizeof(users[i]));
    if (equals(users[i].id,"0000") || !isValid(users[i].id)){
      freeUserIndex = i;
      break;
    }
    // freeUserIndex = 0;
  }
  // load access
  eeprom_read_block(&access, &eaccess, sizeof(access));
}

void writeData() {
  // write users
  int i;
  for (i=0;i<MAX_USER;i++) {
    eeprom_write_block(&users[i], &eusers[i], sizeof(users[i]));
  }

  // write access
  eeprom_write_block(&access, &eaccess, sizeof(access));
}

void put(char c) {
  if (cursor > 14) return;

  lcd_gotoxy(cursor, 1);
  lcd_putchar(c);
  cursor++;
}

void clear() {
  if (cursor < 1) return;
  cursor--;
  lcd_gotoxy(cursor, 1);
  lcd_putchar('');
}

void clearLine() {
  cursor = 0;
  lcd_gotoxy(cursor, 1);
  lcd_puts("                ");
}

void addUser(User u) {
  int j;
  memcpy(&users[freeUserIndex], &u, sizeof(u));
  freeUserIndex++;
  for(j=0;j<4;j++)
  users[freeUserIndex].id[j] = '0';
  writeData();
}

void delUser(User u) {
  int i;
  int j;
  loadData();
  for (i=0;i<MAX_USER;i++) {
    if (equals(users[i].id , u.id)) {
        for (j = i; j < MAX_USER-1; j++) {
          move(users[j].id,users[j+1].id);
          move(users[j].password,users[j+1].password);
        }
        move(users[MAX_USER-1].id,"0000");
        move(users[MAX_USER-1].id,"0000");
        freeUserIndex--;
        break;
    }
  }
  writeData();
  // int i;
  // int j;
  // loadData();
  // for (i=0;i<MAX_USER;i++) {
  //   if (equals(users[i].id , u.id)) {
  //     lcd_clear();
  //     lcd_puts("yay");
  //     delay_ms(1000);
  //     for (j = i; j < MAX_USER-1; j++) {
  //     }
  //     memcpy(&users[freeUserIndex], &u, sizeof(u));
  //     freeUserIndex--;
  //     writeData();
  //  }
  //}
}




char getKey() {
  char pressedKey = '';

  PORTC.0 = 0;
  PORTC.1 = 1;
  PORTC.2 = 1;

  if (PINC.0 == 0) {
    if (PINC.3 == 0) {
      pressedKey = '1';
    }else if (PINC.4 == 0) {
      pressedKey = '4';
    }else if (PINC.5 == 0) {
      pressedKey = '7';
    }else if (PINC.6 == 0) {
      pressedKey = '*';
    }
  }

  PORTC.0 = 1;
  PORTC.1 = 0;
  PORTC.2 = 1;

  if (PINC.1 == 0) {
    if (PINC.3 == 0) {
      pressedKey = '2';
    }else if (PINC.4 == 0) {
      pressedKey = '5';
    }else if (PINC.5 == 0) {
      pressedKey = '8';
    }else if (PINC.6 == 0) {
      pressedKey = '0';
    }
  }

  PORTC.0 = 1;
  PORTC.1 = 1;
  PORTC.2 = 0;

  if (PINC.2 == 0) {
    if (PINC.3 == 0) {
      pressedKey = '3';
    }else if (PINC.4 == 0) {
      pressedKey = '6';
    }else if (PINC.5 == 0) {
      pressedKey = '9';
    }else if (PINC.6 == 0) {
      pressedKey = '#';
    }
  }

  PORTC.0 = 0;
  PORTC.1 = 0;
  PORTC.2 = 0;

  return pressedKey;
}

int authenticate() {
  int i;
  if (equals(currentUser.id , GUEST_ID)) {
    return 1;
  }

  if (equals(currentUser.id , ADMIN_ID) && equals(currentUser.password , ADMIN_PASS)) {
    return 2;
  }

  for (i=0;i<MAX_USER;i++) {
    if (equals(users[i].id , currentUser.id) && equals(users[i].password , currentUser.password)) {
      return 1;
    }
  }
  return 0;
}

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void) {
  char pressedKey = '';
  switch (state) {
    case LOGIN_USER:
    pressedKey = getKey();
    if (pressedKey == '#') {
      cursor = 0;
      state = LOGIN_PASS_INIT;
    }else if (pressedKey == '*') {
      clear();
    }else{
      currentUser.id[cursor] = pressedKey;
      put(pressedKey);
    }
    break;
    case LOGIN_PASS:
    pressedKey = getKey();
    if (pressedKey == '#') {
      cursor = 0;
      state = LOGIN_CHECK;
    }else if (pressedKey == '*') {
      clear();
    }else{
      currentUser.password[cursor] = pressedKey;
      put('*');
    }
    break;
    case ADMIN_CHECK:
    pressedKey = getKey();
    if (pressedKey == '1') {
      state = DOOR_OPEN;
    }else if (pressedKey == '2') {
      state = ADMIN_ADD;
    }else if (pressedKey == '3') {
      state = ADMIN_DEL;
    }else if (pressedKey == '4') {
      state = ADMIN_CNT;
    }else if (pressedKey == '*') {
      state = INIT;
    }else{
      lcd_puts("invalid input");
      delay_ms(1000);
      state = ADMIN_MENU;
    }
    break;
    case ADMIN_ADD_ID:
    pressedKey = getKey();
    if (pressedKey == '#') {
      cursor = 0;
      state = ADMIN_ADD_PASS_INIT;
    }else if (pressedKey == '*') {
      clear();
    }else{
      currentUser.id[cursor] = pressedKey;
      put(pressedKey);
    }

    break;
    case ADMIN_ADD_PASS:
    pressedKey = getKey();

    if (pressedKey == '#') {
      cursor = 0;
      if(freeUserIndex < MAX_USER)
        addUser(currentUser);
      else{
        lcd_clear();
        lcd_puts("full");
        delay_ms(2000);
      }
      state = ADMIN_MENU;
    }else if (pressedKey == '*') {
      clear();
    }else{
      currentUser.password[cursor] = pressedKey;
      put('*');
    }
    break;
    case ADMIN_DEL_CHECK:
    pressedKey = getKey();
    if (pressedKey == '#') {
      cursor = 0;
      delUser(currentUser);
      state = ADMIN_MENU;
    }else if (pressedKey == '*') {
      clear();
    }else{
      currentUser.id[cursor] = pressedKey;
      put(pressedKey);
    }
    break;
    case ADMIN_CNT_CHECK:
    pressedKey = getKey();

    if (pressedKey == '1') {
      access = 1;
      writeData();
      lcd_clear();
      lcd_puts("successful");
      delay_ms(1000);
      state = ADMIN_MENU;
    }else if (pressedKey == '2') {
      access = 2;
      writeData();
      lcd_clear();
      lcd_puts("successful");
      delay_ms(1000);
      state = ADMIN_MENU;
    }else if (pressedKey == '3') {
      access = 3;
      writeData();
      lcd_clear();
      lcd_puts("successful");
      delay_ms(1000);
      state = ADMIN_MENU;
    }else if (pressedKey == '*') {
      state = ADMIN_MENU;
    }else{
      lcd_clear();
      lcd_puts("invalid input");
      delay_ms(1000);
      state = ADMIN_MENU;
    }
    break;
  }
}

void main(void) {
  // Declare your local variables here

  // Input/Output Ports initialization
  // Port A initialization
  // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
  DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
  // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
  PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

  // Port B initialization
  // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
  DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
  // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
  PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

  // Port C initialization
  // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
  DDRC=(1<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
  // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
  PORTC=(0<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

  // Port D initialization
  // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
  DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
  // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
  PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

  // Timer/Counter 0 initialization
  // Clock source: System Clock
  // Clock value: Timer 0 Stopped
  // Mode: Normal top=0xFF
  // OC0 output: Disconnected
  TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
  TCNT0=0x00;
  OCR0=0x00;

  // Timer/Counter 1 initialization
  // Clock source: System Clock
  // Clock value: Timer1 Stopped
  // Mode: Normal top=0xFFFF
  // OC1A output: Disconnected
  // OC1B output: Disconnected
  // Noise Canceler: Off
  // Input Capture on Falling Edge
  // Timer1 Overflow Interrupt: Off
  // Input Capture Interrupt: Off
  // Compare A Match Interrupt: Off
  // Compare B Match Interrupt: Off
  TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
  TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
  TCNT1H=0x00;
  TCNT1L=0x00;
  ICR1H=0x00;
  ICR1L=0x00;
  OCR1AH=0x00;
  OCR1AL=0x00;
  OCR1BH=0x00;
  OCR1BL=0x00;

  // Timer/Counter 2 initialization
  // Clock source: System Clock
  // Clock value: Timer2 Stopped
  // Mode: Normal top=0xFF
  // OC2 output: Disconnected
  ASSR=0<<AS2;
  TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
  TCNT2=0x00;
  OCR2=0x00;

  // Timer(s)/Counter(s) Interrupt(s) initialization
  TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

  // External Interrupt(s) initialization
  // INT0: On
  // INT0 Mode: Rising Edge
  // INT1: Off
  // INT2: Off
  GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
  MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);
  MCUCSR=(0<<ISC2);
  GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);

  // USART initialization
  // USART disabled
  UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

  // Analog Comparator initialization
  // Analog Comparator: Off
  // The Analog Comparator's positive input is
  // connected to the AIN0 pin
  // The Analog Comparator's negative input is
  // connected to the AIN1 pin
  ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
  SFIOR=(0<<ACME);

  // ADC initialization
  // ADC disabled
  ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

  // SPI initialization
  // SPI disabled
  SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

  // TWI initialization
  // TWI disabled
  TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

  // Alphanumeric LCD initialization
  // Connections are specified in the
  // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
  // RS - PORTA Bit 1
  // RD - PORTA Bit 2
  // EN - PORTA Bit 3
  // D4 - PORTA Bit 4
  // D5 - PORTA Bit 5
  // D6 - PORTA Bit 6
  // D7 - PORTA Bit 7
  // Characters/line: 16
  lcd_init(16);

  // Global enable interrupts
  #asm("sei")
  ADMIN_ID[0] = '1';
  ADMIN_ID[1] = '0';
  ADMIN_ID[2] = '0';
  ADMIN_ID[3] = '0';
  ADMIN_PASS[0] = '1';
  ADMIN_PASS[1] = '1';
  ADMIN_PASS[2] = '1';
  ADMIN_PASS[3] = '1';
  GUEST_ID[0] = '0';
  GUEST_ID[1] = '0';
  GUEST_ID[2] = '0';
  GUEST_ID[3] = '0';
  GUEST_PASS[0] = '0';
  GUEST_PASS[1] = '0';
  GUEST_PASS[2] = '0';
  GUEST_PASS[3] = '0';
  while (1) {
    switch (state) {
      case IDLE:
      break;

      case INIT:
      PORTC.7 = 0;
      lcd_clear();
      lcd_puts("loading data...");
      loadData();
      lcd_clear();
      lcd_puts("loaded");
      lcd_clear();
      lcd_puts("user id:");
      lcd_gotoxy(0, 1);
      cursor = 0;
      state = LOGIN_USER;
      break;

      case LOGIN_PASS_INIT:
      lcd_clear();
      lcd_puts("password:");
      lcd_gotoxy(0, 1);
      cursor = 0;
      state = LOGIN_PASS;
      break;
      case ADMIN_ADD_PASS_INIT:
      lcd_clear();
      lcd_puts("password:");
      lcd_gotoxy(0, 1);
      cursor = 0;
      state = ADMIN_ADD_PASS;
      break;

      case LOGIN_CHECK:
      lcd_clear();
      lcd_puts("checking...");

      switch (authenticate()) {
        case 0:
        state = LOGIN_ERROR;
        break;
        case 1:
        state = USER_LOGGED;
        break;
        case 2:
        state = ADMIN_MENU;
        break;
      }
      break;

      case LOGIN_ERROR:
      lcd_clear();
      lcd_puts("wrong id or password");
      lcd_gotoxy(0, 1);
      delay_ms(1500);
      state = INIT;
      break;

      case USER_LOGGED:
      lcd_clear();
      lcd_puts("checking access");
      delay_ms(1500);
      lcd_clear();

      if (access < 2) {
        lcd_puts("access granted");
        state = DOOR_OPEN;
      }else {
        lcd_puts("no access");
      }
      break;
      case GUEST_LOGGED:
      lcd_clear();
      lcd_puts("checking access");
      delay_ms(1500);
      lcd_clear();

      if (access < 2) {
        lcd_puts("access granted");
        state = DOOR_OPEN;
      }else {
        lcd_puts("no access");
      }

      delay_ms(2000);
      state = INIT;
      break;

      case ADMIN_MENU:
      lcd_clear();
      lcd_puts("1.open 2.add    3.del 4.ac *.exc");
      state = ADMIN_CHECK;
      break;

      case ADMIN_ADD:
      lcd_clear();
      lcd_gotoxy(0,0);
      lcd_puts("enter user id:");
      state = ADMIN_ADD_ID;
      break;

      case ADMIN_DEL:
      lcd_clear();
      lcd_gotoxy(0,0);
      lcd_puts("enter user id:");
      state = ADMIN_DEL_CHECK;
      break;

      case ADMIN_CNT:
      lcd_clear();
      lcd_puts("1 public");
      lcd_gotoxy(8,0);
      lcd_puts("2 users only");
      lcd_gotoxy(0,1);
      lcd_puts("3 none");
      lcd_gotoxy(8,1);
      lcd_puts("* back");
      state = ADMIN_CNT_CHECK;
      break;

      case DOOR_OPEN:
      PORTC.7 = 1;
      delay_ms(3000);
      state = INIT;
      break;
    }
  }
}
