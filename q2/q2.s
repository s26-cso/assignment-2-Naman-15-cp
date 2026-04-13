.section .rodata
formatstr: .string "%lld "  
newlinestr: .string "\n" 

.global main
main:
    addi sp,sp,-48
    sd ra,32(sp)
    sd s0,24(sp)    # to store the argc
    sd s1,16(sp)    # to store the argv(the pointer pointing to an array of pointers)
    sd s2,8(sp)     # to store the malloc value pointer
    sd s3,0(sp)     # to store the counter

    mv s0,a0
    mv s1,a1
    addi a0,a0,-1
    slli a0,a0,3
    call malloc
    mv s2,a0   
    addi s0,s0,-1
    addi s3,x0,0  

input:  
    addi s3,s3,1
    slli t1,s3,3    # t1 = i * 8
    add t1,s1,t1    # t1 = base argv (s1) + offset
    ld a0,0(t1)     # a0 = the actual string pointer for argv[i]
    call atoll      # returns a value and not a pointer

    mv t3,a0
    mv t0,s2
    addi s3,s3,-1
    slli t1,s3,3
    add t1,t1,t0
    addi s3,s3,1
    sd t3,0(t1)

    blt s3,s0,input

stop:
    slli a0, s0, 3      # Number of elements * 8 bytes
    call malloc
    mv s4, a0           # s4 stores pointer to our result array
    mv s5,sp            # s5 stores the starting sp pointer   
    addi t0,x0,0
    addi t2,x0,-1

loop:
    slli t1,t0,3
    add t1,t1,s4
    sd t2,0(t1)
    addi t0,t0,1
    blt t0,s0,loop

    
anssol:
    addi t0,x0,0

mainforloop:
    bge t0,s0,mainend

    slli t1,t0,3        # i=i*8
    add t2,s2,t1        # t1 is the pointer to arr[i]
    ld t2,0(t2)         # t2 is arr[i]

subsidarywhileloop:
    # while loop
    beq sp,s5,comeback
    ld t3,0(sp)         # index array
    slli t3,t3,3
    add t4,s2,t3        # t3 contains the value for stack top
    ld t4,0(t4)         # t4 contains the value for array[stack pointer]
    bge t4, t2, comeback    
    add t5,t3,s4
    sd t0,0(t5)         # store i in result
    addi sp,sp,8
    beq x0,x0,subsidarywhileloop

comeback:
    addi sp,sp,-8
    sd t0,0(sp)
    addi t0,t0,1
    beq x0,x0,mainforloop

mainend:
    addi s3, x0, 0          # reusing s3 as our counter i

printloop:
    bge s3, s0, printdone 
    slli t1, s3, 3          # t1=i*8
    add t1, s4, t1          # t1=base of result array (s4) + offset
    ld a1, 0(t1)            # a1 = result[i]

    la a0, formatstr        # load the format string into a0 (Argument 1 for printf)
    call printf

    addi s3, s3, 1    
    j printloop

printdone:
    la a0, newlinestr
    call printf

    mv sp, s5               # reload pointer

    ld ra, 32(sp)
    ld s0, 24(sp)
    ld s1, 16(sp)
    ld s2, 8(sp)
    ld s3, 0(sp)
    addi sp, sp, 48

    ret