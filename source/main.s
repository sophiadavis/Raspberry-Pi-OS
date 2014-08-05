// Instructions to assembler
.section .init // where to put code (puts code in section .init at start of output)
.globl _start // stop warning msg
_start:

ldr r0,=0x20200000 // set pointer to GPIO controller

// Enable OUTPUT to 16th GPIO pin
mov r1,#1 // #num -- literal decimal numbers (mov is faster than ldr -- does not involve memory interaction)
lsl r1,#18 // we want 18th GPIO pin
str r1,[r0,#4] // store register -- store value at r1 into next address

// Initialize r3 to 0 (LED off)
mov r3,#0

// Prepare to turn pin 16 off (=LED on)
mov r1,#1
lsl r1,#16

blinkLoop$:
// wait
mov r2,#0x3F0000
wait$:
sub r2,#1
cmp r2,#0
bne wait$
cmp r3,#0

bne turnoff$
b turnon$

turnon$:
str r1,[r0,#40]
mov r3,#1
b blinkLoop$

turnoff$:
str r1,[r0,#28]
mov r3,#0
b blinkLoop$
