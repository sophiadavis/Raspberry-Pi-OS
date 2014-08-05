.globl GetGpioAddress // make this label accessible to all files
GetGpioAddress:
    ldr r0,=0x20200000 // stores GPIO controller address in r0
    mov pc,lr
            // pc contains address of the next instruction to be run
            // lr contains the return address
            // we are loading the return address as the next instruction to run


.globl SetGpioFunction
SetGpioFunction:
               // checking input (dont just assume inputs will be correct)
    cmp r0,#53 // one input -- it must be a GPIO pin number, so it must be between 0 and 53
    cmpls r1,#7 // each pin has 8 functions
                // cmpls is run only if r0 <= #53
    movhi pc,lr // and if r1 is greater than 7, go back to caller
    // done checking inputs

    push {lr} // push return address
    mov r2,r0 // move GPIO pin number out of r0 (we know GetGpioAddress will overwrite this)
    bl GetGpioAddress
        // bl calls a function by updating lr to the next instruction address, then branching to function

    // Find which block of 10 pins corresponds to our pin (and increment GPIO address accordingly)
    // Division is slower than repeated subtraction
    // PROBLEM! resets all other pin values to 0
    functionLoop$:
        cmp r2,#9
        subhi r2,#10
        addhi r0,#4
        bhi functionLoop$
    
        add r2, r2,lsl #1 // = multiplication by 3 (r2*2 + r2, or bitshift left by 1 place + r2)
        lsl r1,r2 // r2 contains offset(?) for the pin we want to access, so shift the function value left that much
        str r1,[r0]
        pop {pc}
    
.globl SetGpio
SetGpio:
    pinNum .req r0 // create aliases for registers
    pinVal .req r1
    
    cmp pinNum,#53  // check for valid pin number
    movhi pc,lr     // return immediately if not
    
    push {lr}       // preserve lr before calling GetGpioAddress
    
    mov r2,pinNum   // put pinNumber in r2
    .unreq pinNum   // remove alias
    pinNum .req r2  // ... and remake it on r2
    bl GetGpioAddress
    gpioAddr .req r0
    
    // ???????????????????????????????????????
    pinBank .req r3         // ???????????????????????????????????????
    lsr pinBank,pinNum,#5   // divide pinNum by 32 (**put in pinBank???**)
    lsl pinBank,#2          // and then multiply by 4 to get correct set of bytes
                            // cannot combine previous 2 instructions bc of rounding
    
    add gpioAddr,pinBank
    .unreq pinBank
    
    // now we need to generate a number with the correct bit (28 or 40) set
    and pinNum,#31
    setBit .req r3
    mov setBit,#1
    lsl setBit,pinNum
    .unreq pinNum
    
    teq pinVal,#0   // test equality -- we want to turn OFF if pinVal is 0
    .unreq pinVal
    streq setBit,[gpioAddr,#40]
    strne setBit,[gpioAddr,#28]
    .unreq setBit
    .unreq gpioAddr
    pop {pc}


