GetCurrentTimeStamp:
    push {lr}
    ldr r2,=0x20003004 // address of counter
    ldrd r0,r1,[r2,#4] // get starting time stamp
    pop {pc}

.globl Wait
Wait:
    push {lr}
    delay .req r3
    ldr delay,=500000
    
    // get ending time
    bl GetCurrentTimeStamp
    add r0,delay
    mov r1,r0
    bombTime .req r1
    
    .unreq delay
    currentTime .req r0
    
    waitLoop$:
        bl GetCurrentTimeStamp
        cmp bombTime,currentTime
        bhi waitLoop$
        
    .unreq bombTime
    .unreq currentTime
    pop {pc}
