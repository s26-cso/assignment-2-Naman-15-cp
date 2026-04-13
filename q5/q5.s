.section .rodata
filename: .string "input.txt"
filemode: .string "r"
yesmessage: .string "Yes\n"
nomessage: .string "No\n"

.global main
main:
    addi sp, sp, -48   
    sd ra,40(sp)        # return address
    sd s0,32(sp)        # s0 = file pointer
    sd s1,24(sp)        # s1 = total file size
    sd s2,16(sp)        # s2 = last index
    sd s3,8(sp)         # s3 = first index
    sd s4,0(sp)         # s4 = safely holds the left character and no need for right as we'll just take it from a0 form fgetc

    la a0,filename      
    la a1,filemode
    call fopen
    mv s0,a0

    li a1,0
    li a2,2
    call fseek
    mv a0,s0
    call ftell
    mv s1,a0
    addi s3,x0,0
    addi s2,s1,-1

whileloop:
    bge s3,s2,ispalindrome
    mv a0, s0            
    mv a1, s3            
    li a2, 0             
    call fseek

    mv a0,s0
    call fgetc
    mv s4,a0            # stored left character in s4

    mv a0, s0            
    mv a1, s2            
    li a2, 0             
    call fseek

    mv a0,s0
    call fgetc
    mv t1,a0            # stored right character in t1
    
    bne s4,t1,notpalindrome
    addi s3,s3,1
    addi s2,s2,-1

    beq x0,x0,whileloop

notpalindrome:
    la a0, nomessage
    call printf
    beq x0,x0,cleanup

ispalindrome:
    la a0, yesmessage
    call printf

cleanup:
    mv a0, s0
    call fclose            # Close the file before we leave
    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    ld s4, 0(sp)
    addi sp, sp, 48

    li a0, 0
    ret