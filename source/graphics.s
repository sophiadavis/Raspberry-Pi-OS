.globl GetMailboxBase
GetMailboxBase:
    ldr r0,=0x2000B880
    mov pc,lr

    
// r0 -- what to write
// r1 -- mailbox
.globl MailboxWrite
MailboxWrite:
    tst r0,#0b1111 // check for valid input -- lowest 4 bits should be 0
    movne pc,lr
    cmp r1,#15 // check that r1 contains a valid mailbox (less than 16??)
    movhi pc,lr
    
    channel .req r1 // write or read
    value .req r2 // save all our values
    mov value,r0

    push {lr}
    bl GetMailboxBase
    mailbox .req r0
    
    wait1$:
        status .req r3 // read from the status field
        ldr status,[mailbox,#0x18]
        
        tst status,#0x80000000 // checks that top bit of status is 0
        .unreq status
        bne wait1$
    
    add value,channel // combine channel and value
    .unreq channel
    
    str value,[mailbox,#0x20] // stores result to write field
    .unreq value
    .unreq mailbox
    pop {pc}
    
    
// r0 -- what to read from
.globl MailboxRead
MailboxRead:
    cmp r0,#15
    movhi pc,lr
    
    channel .req r1
    mov channel,r0
    
    push {lr}
    bl GetMailboxBase
    mailbox .req r0    
    
    rightmail$:
        wait2$:
            status .req r2 // read from the status field
            ldr status,[mailbox,#0x18]
    
            tst status,#0x40000000 // checks that 30th bit of status is 0
            bne wait2$              // if not, we cant write, so we need to check it again
    
        mail .req r2
        ldr mail,[mailbox,#0] //  read next item from mailbox
        
        inchan .req r3 // check that the channel of the mailbox we just read is the one we were supplied
        and inchan,mail,#0b1111 // take first 4 bits of mailbox represent channel
        teq inchan,channel
        .unreq inchan
        bne rightmail$
        .unreq mailbox
        .unreq channel
        
        and r0,mail,#0xfffffff0 // take everything in mailbox except the last 4 bits -- this is the actual info
        .unreq mail
        pop {pc}

