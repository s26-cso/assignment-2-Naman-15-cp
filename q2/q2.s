.section .rodata
formatstr:       .string "%lld "   # For all elements except the last
formatstr_last:  .string "%lld"    # For the very last element (NO SPACE!)
newlinestr:      .string "\n"

.text
.global main
main:
    addi sp, sp, -64    # Bumped to 64 bytes (8 registers * 8 bytes)
    sd ra, 56(sp)
    sd s0, 48(sp)       # argc
    sd s1, 40(sp)       # argv
    sd s2, 32(sp)       # input array pointer
    sd s3, 24(sp)       # counter
    sd s4, 16(sp)       # result array pointer (SAFELY SAVED)
    sd s5, 8(sp)        # original sp for monotonic stack (SAFELY SAVED)

    mv s0, a0
    mv s1, a1
    
    addi a0, s0, -1     # Allocate memory for input array: (argc - 1) * 8 bytes
    slli a0, a0, 3
    call malloc
    mv s2, a0   
    
    # Adjust s0 to actual number of elements
    addi s0, s0, -1
    addi s3, x0, 0  
input:  
    addi s3, s3, 1
    slli t1, s3, 3      # t1 = i * 8
    add t1, s1, t1      # t1 = base argv (s1) + offset
    ld a0, 0(t1)        # a0 = string pointer for argv[i]
    call atoll          # convert to long long

    mv t3, a0
    mv t0, s2
    addi s3, s3, -1
    slli t1, s3, 3
    add t1, t1, t0
    addi s3, s3, 1
    sd t3, 0(t1)        # Store in input array

    blt s3, s0, input

stop:
    slli a0, s0, 3      # Number of elements * 8 bytes
    call malloc
    mv s4, a0           # s4 stores pointer to our result array
    mv s5, sp           # s5 stores the starting sp pointer (Monotonic stack base)
    addi t0, x0, 0
    addi t2, x0, -1

loop:
    slli t1, t0, 3
    add t1, t1, s4
    sd t2, 0(t1)
    addi t0, t0, 1
    blt t0, s0, loop

anssol:
    addi t0, x0, 0

mainforloop:
    bge t0, s0, mainend

    slli t1, t0, 3        # i=i*8
    add t2, s2, t1        # t1 is the pointer to arr[i]
    ld t2, 0(t2)          # t2 is arr[i]

subsidarywhileloop:
    beq sp, s5, comeback
    ld t3, 0(sp)          # index array
    slli t3, t3, 3
    add t4, s2, t3        # t3 contains the value for stack top
    ld t4, 0(t4)          # t4 contains the value for array[stack pointer]
    bge t4, t2, comeback  
    
    add t5, t3, s4
    sd t0, 0(t5)          # store i in result
    addi sp, sp, 8        # pop from monotonic stack
    beq x0, x0, subsidarywhileloop

comeback:
    addi sp, sp, -8       # push current index to monotonic stack
    sd t0, 0(sp)
    addi t0, t0, 1
    beq x0, x0, mainforloop

mainend:
    addi s3, x0, 0        # reusing s3 as our counter i

printloop:
    # Stop the loop at s0 - 1 (the second-to-last element)
    addi t2, s0, -1
    bge s3, t2, printlast 

    slli t1, s3, 3          
    add t1, s4, t1          
    ld a1, 0(t1)            

    la a0, formatstr        # Print with trailing space
    call printf

    addi s3, s3, 1      
    j printloop

printlast:
    # Print the very last element without a space
    slli t1, s3, 3
    add t1, s4, t1
    ld a1, 0(t1)

    la a0, formatstr_last   # Print WITHOUT trailing space
    call printf

printdone:
    la a0, newlinestr       # Print the clean newline
    call printf
    mv sp, s5               # Clear the monotonic stack back to base

    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    ld s4, 16(sp)           # RESTORE S4
    ld s5, 8(sp)            # RESTORE S5
    addi sp, sp, 64         # Deallocate stack frame

    li a0, 0                # Return 0 gracefully
    ret