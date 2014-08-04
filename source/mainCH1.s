// Instructions to assembler
.section .init // where to put code (puts code in section .init at start of output)
.globl _start // stop warning msg
_start:

ldr r0,=0x20200000 // set pointer to GPIO controller

// Enable OUTPUT to 16th GPIO pin
mov r1,#1 // #num -- literal decimal numbers (mov is faster than ldr -- does not involve memory interaction)
lsl r1,#18 // we want 18th GPIO pin
str r1,[r0,#4]

// Turn pin 16 off (=LED on)
mov r1,#1
lsl r1,#16
str r1,[r0,#40]

// infinite loop
loop$: // a label for next line
b loop$ // b = branch
