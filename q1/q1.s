.global make_node
make_node:
    addi sp,sp,-16
    sd ra,0(sp)   #storing return address
    sd s1,8(sp)   #storing s1 value
    mv s1,a0
    li a0,24     # 4(int)+4(offset)+8 left address+8 right address
    call malloc    # address will be stored in a0

    sw s1,0(a0)
    sd x0,8(a0)
    sd x0,16(a0)

    ld ra,0(sp)
    ld s1,8(sp)
    addi sp,sp,16
    ret
    
.global insert
insert:
    addi sp,sp,-32
    sd ra,0(sp)
    sd s1,8(sp)
    sd s2,16(sp)
    
    mv s1,a0        # s1 storing the root nodes value
    mv s2,a1        # s2 storing the value

    bne s1, x0, solution

    mv a0,s2                
    call make_node          # call fuction can somehow use a1 so please use the store value a0 will store the new value
    mv a1,s2
    beq x0,x0, end

solution:
    lw t1,0(s1)             # the value itself is a no. in int
    ble t1,s2,moveright     

moveleft:
    ld a0,8(s1)
    mv a1,s2
    call insert             # a0 will store the childs pointer
    sd a0,8(s1)
    mv a1,s2                
    mv a0,s1                #substituting the root nodes value
    beq x0,x0,end

moveright:
    ld a0,16(s1)
    mv a1,s2
    call insert
    sd a0,16(s1)
    mv a1,s2
    mv a0,s1
    beq x0,x0,end

end:
    ld ra,0(sp)
    ld s1,8(sp)
    ld s2,16(sp)
    addi sp,sp,32
    ret

.global get
get:
    bne a0, x0, solution1
    mv a0,x0                
    beq x0,x0,getend

solution1:
    lw t1,0(a0)             # the value itself is a no. in int
    beq t1,a1,getend           # the value of a0 is s1 so no need for change
    ble t1,a1,moveright1     

moveleft1:
    ld a0,8(a0)
    beq x0,x0,get            # a0 will store the childs pointer

moveright1:
    ld a0,16(a0)
    beq x0,x0,get

getend:
    ret

.global getAtMost
getAtMost:
    addi t0,x0,-1                #t0 will store the answer

ans1:
    bne a1, x0, solution2
    mv a0,t0                
    beq a1,x0,getend1

solution2:
    lw t1,0(a1)             # the value itself is a no. in int
    ble t1,a0,moveright2     

moveleft2:
    ld a1,8(a1)
    beq x0,x0,ans1            # a0 will store the childs pointer

moveright2:
    mv t0,t1
    ld a1,16(a1)
    beq x0,x0,ans1

getend1:
    ret
