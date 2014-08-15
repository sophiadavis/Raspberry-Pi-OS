// differentiate between data and code by putting data in .data section        
// separation ensures that -- after we implement security -- we can know what parts of code can and cant be executed
.section .data
.align 2 // ensures that the address of the next line is a multiple of 2^num (ldr only works at addresses that are multiples of 4)
pattern:
    .int 0b11111111101010100010001000101010 // outputs number val
        // 0 is light on, 1 is light off
        // read from right to left


// Instructions to assembler
.section .init // where to put code (puts code in section .init at start of output)
.globl _start // stop warning msg
_start:

b main
.section .text
main:
    mov sp,#0x8000 // default load address
    mov r0,#1024 // width
    mov r1,#768 // height
    mov r2,#16 // bit depth
    
    bl InitialiseFrameBuffer
    
    // test for return value of 0 (graphics processor did not give us a frame buffer)
    teq r0,#0
    bne noError$
    
    mov r0,#16
    mov r1,#1
    bl SetGpioFunction
    mov r0,#16
    mov r1,#0
    bl SetGpio
    
    error$:
        b error$
    
    noError$:
        fbInfoAddr .req r4
        mov fbInfoAddr,r0
    
    render$:
        fbAddr .req r3
        ldr fbAddr,[fbInfoAddr,#32]
        
        colour .req r0
        y .req r1
        mov y,#768
        drawRow$:
            x .req r2
            mov x,#1024
            
            drawPixel$:
                strh colour,[fbAddr] // store low half word (current color)
                add fbAddr,#2
                sub x,#1
                teq x,#0
                bne drawPixel$
            
            sub y,#1
            add colour,#1
            teq y,#0
            bne drawRow$
        
        b render$
    
    .unreq fbAddr
    .unreq fbInfoAddr
        

