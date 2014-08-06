GetCurrentTimeStamp:
    //push {lr}
    ldr r2,=0x20003004 // address of counter
    ldrd r0,r1,[r2,#0] // get starting time stamp // change #4 to #0?
    //pop {pc}
    mov pc,lr

.globl Wait
Wait:
    push {lr}
    delay .req r5
    ldr delay,=500000
    
    // get ending time
    bl GetCurrentTimeStamp
    add r0,delay
    mov r1,r0
    bombTime .req r1
    
    .unreq delay
    
    waitLoop$:
        bl GetCurrentTimeStamp
        currentTime .req r0
        cmp bombTime,currentTime
        bhi waitLoop$
        
    .unreq bombTime
    .unreq currentTime
    pop {pc}
