#include <stdint.h>

volatile uint8_t* uart0 = (uint8_t*)0x10009000;

void write(const char* str)
{
   while(*str)
   {
      *uart0 = *str++;
   }
}

const unsigned int val  asm("beef") =  0XDEADBEEF;  

int main(){
   
   const char* s = "Hello World from bare-metal!!!\n";
   write(s);
   *uart0 = 'A';
   *uart0 = 'B';
   *uart0 = 'C';
   *uart0 = '\n';

   while( *s != '\n') {
      *uart0 = *s;
      ++s;
   }

   asm(
   "ldr r3, =beef;"
   "ldr r0, [r3];"
   "ldr r1, [r3];"
   "ldr r2, [r3];"
         );
   while(1);

   return 0;
}
