GetCurrentTimeStamp:
    push {lr}
    ldr r2,=0x20003004 // address of counter
    ldr r0,[r2,#0] // get starting time stamp
    pop {pc}
    //mov pc,lr

.globl Wait
Wait:
    push {lr}
    push {r6}
    delay .req r6
    mov delay,r0
    
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
    pop {r6}
    pop {pc}
