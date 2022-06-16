
#include <stdint.h>
#include <stivale2.h>

#define COM1 0x3f8
#define outb(port_, val_) ({ asm volatile ("outb %0, %1" : : "a"(val_), "Nd"(port_)); })
#define inb(port_) ({ uint8_t ret; asm volatile ( "inb %1, %0" : "=a"(ret) : "Nd"(port_) ); ret;})

static int kernel_init_serial() {
   outb(COM1 + 1, 0x00);
   outb(COM1 + 3, 0x80);
   outb(COM1 + 0, 0x03);
   outb(COM1 + 1, 0x00);
   outb(COM1 + 3, 0x03);
   outb(COM1 + 2, 0xC7);
   outb(COM1 + 4, 0x0B);
   outb(COM1 + 4, 0x1E);
   outb(COM1 + 0, 0xAE);

   if(inb(COM1 + 0) != 0xAE) {
      return 1;
   }
   
   outb(COM1 + 4, 0x0F);
   return 0;
}


void _start(struct stivale2_struct *stivale2_struct) {
    for (;;) {
        asm ("hlt");
    }
}
