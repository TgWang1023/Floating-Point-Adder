# Tiange Wang Lab02. ID: 3717659
.data
    A: .float 12.5
    B: .float 3.5
    C: .float 0.0
.text
main:
    la $t0, A
    lw $a0, 0($t0) # $a0 = num1
    la $t1, B
    lw $a1, 0($t1) # $a1 = num2
    jal MYADD
    la $t2, C
    sw $v0, 0($t2) # $v0 = result
    li $v0, 10
    syscall
MYADD:
    srl $t0, $a0, 23
    andi $t0, $t0, 0x00FF # $t0 = num1 exponent
    srl $t1, $a1, 23
    andi $t1, $t1, 0x00FF # $t1 = num2 exponent
    blt	$t0, $t1, move_num_one
move_num_two: # $t0 >= $t1
    sll $t2, $a1, 9
    srl $t2, $a1, 9
    sub $t3, $t0, $t1
    srlv $t2, $t2, $t3
    move $t1, $t0
    j mantissa
move_num_one: # $t0 < $t1
    sll $t2, $a0, 9
    srl $t2, $a0, 9
    sub $t3, $t1, $t0
    srlv $t2, $t2, $t3
    move $t0, $t1
mantissa:
    jr $ra