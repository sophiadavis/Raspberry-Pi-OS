.section .data
.align 4
.globl FrameBufferInfo
    FrameBufferInfo:
        .int 1024 /* #0 Physical Width */
        .int 768 /* #4 Physical Height */
        .int 1024 /* #8 Virtual Width */
        .int 768 /* #12 Virtual Height */
        .int 0 /* #16 GPU - Pitch */
        .int 16 /* #20 Bit Depth  -- 16 = HIGH COLOR*/
        .int 0 /* #24 X offset -- num pixels to skip in top-left corner */
        .int 0 /* #28 Y offset */
        .int 0 /* #32 GPU - Pointer */
        .int 0 /* #36 GPU - Size */
        
.section .text
.globl InitialiseFrameBuffer
InitialiseFrameBuffer:
    width .req r0
    height .req r1
    bitDepth .req r2
    cmp width,#4096 // width and height must be <= 32
    cmpls bitDepth,#32
    result .req r0
    movhi result,#0
    movhi pc,lr
    
    fbInfoAddr .req r4
    push {r4,lr}
    ldr fbInfoAddr,=FrameBufferInfo
    str width,[r4,#0]
    str height,[r4,#4]
    str width,[r4,#8]
    str bitDepth,[r4,#20]
    .unreq width
    .unreq height
    .unreq bitDepth
    
    mov r0,fbInfoAddr
    add r0,#0x40000000 
    mov r1,#1
    bl MailboxWrite
    
    mov r0,#1 // channel to write to in r0
    bl MailboxRead
    
    teq result,#0
    movne result,#0
    popne {r4,pc}
    .unreq result
    .unreq fbInfoAddr // returns frame buffer info address
    

    
    
