// Instructions to assembler
.section .init // where to put code (puts code in section .init at start of output)
.globl _start // stop warning msg
_start:

b main
.section .text
main:
    mov sp,#0x8000 // default load address
    
    switchReg .req r6
    mov switchReg,#0

    // enable output to GPIO pin 16
    pinNum .req r0
    pinFunc .req r1
    mov pinNum,#16
    mov pinFunc,#1
    bl SetGpioFunction
    .unreq pinNum
    .unreq pinFunc

    blinkLoop$: 
        
        //ldr r0,=500000
        bl Wait
    
        cmp switchReg,#0
        bne turnOff$
        b turnOn$
    
    turnOff$:
        pinNum .req r0
        pinVal .req r1
        mov pinNum,#16
        mov pinVal,#0 // 0 bc OFF
        bl SetGpio
        .unreq pinNum
        .unreq pinVal
        mov switchReg,#0
        b blinkLoop$
    
    turnOn$:
        pinNum .req r0
        pinVal .req r1
        mov pinNum,#16
        mov pinVal,#1
        bl SetGpio
        .unreq pinNum
        .unreq pinVal
        mov switchReg,#1
        b blinkLoop$
