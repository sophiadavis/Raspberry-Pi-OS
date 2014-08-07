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
    
    
    //prtn .req r4
    ldr ptrn,=pattern
    ldr ptrn,[ptrn]
    seq .req r5
    mov seq,#0 // will be used as sequence position
    
    // puts a non-zero into r1 iff there is a 1 in the current part of the pattern
    mov r1,#1
    lsl r1,seq
    and r1,ptrn
    

    blinkLoop$: 
        
        ldr r0,=250000
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

// differentiate between data and code by putting data in .data section        
// separation ensures that -- after we implement security -- we can know what parts of code can and cant be executed
.section .data
.align 2 // ensures that the address of the next line is a multiple of 2^num (ldr only works at addresses that are multiples of 4)
pattern:
    .int 0b11111111101010100010001000101010 // outputs number val


