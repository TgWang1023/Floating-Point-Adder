# Tiange Wang Lab02. ID: 3717659
.data
    A: .float 12.5
    B: .float 3.5
    C: .float 0.0
.text
main:
    addi $sp, $sp, -20
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $ra, 16($sp)
    la $t0, A
    lw $a0, 0($t0)
    la $t1, B
    lw $a1, 0($t1)
    jal MYADD
    la $t2, C
    sw $v0, 0($t2) # $v0 = result
    j exit
MYADD:
    move $s0, $a0 # $s0 = num1
    move $s1, $a1 # $s1 = num2
    srl $t0, $s0, 23
    andi $s2, $t0, 0x00FF # $s2 = num1 exponent
    srl $t1, $s1, 23
    andi $s3, $t1, 0x00FF # $s3 = num2 exponent
    blt	$s2, $s3, move_num_one
move_num_two: # $s2 >= $s3
    sll $t0, $s1, 9
    srl $t0, $s1, 9
    sub $t1, $s2, $s3
    srlv $t0, $t0, $t1
    move $s3, $t0
    j mantissa
move_num_one: # $s2 < $s3
    sll $t0, $s0, 9
    srl $t0, $s0, 9
    sub $t1, $s3, $s2
    srlv $t0, $t0, $t1
    move $s2, $t0
mantissa:
    jr $ra
exit:
    lw $ra, 16($sp)
    lw $s3, 12($sp)
    lw $s2, 8($sp)
    lw $s1, 4($sp)
    lw $s0, 0($sp)
    addi $sp, $sp, 20
    li $v0, 10
    syscall