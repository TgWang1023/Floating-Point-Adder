# Tiange Wang Lab02. ID: 3717659
.data
    A: .float 12.5
    B: .float 3.5
    C: .float 0.0
.text
main:
    addi $sp, $sp, -28
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $ra, 24($sp)
    la $t0, A
    lw $a0, 0($t0)
    la $t1, B
    lw $a1, 0($t1)
    jal MYADD
    la $t2, C
    sw $v0, 0($t2) # $v0 = result
    j exit
MYADD:
    move $s0, $a0
    move $s1, $a1
    srl $t0, $s0, 23
    andi $s2, $t0, 0x00FF # $s2 = num1 exponent
    srl $t0, $s1, 23
    andi $s3, $t0, 0x00FF # $s3 = num2 exponent
    sll $t0, $s0, 9
    srl $s4, $t0, 9 # $s4 = num1 mantissa
    sll $t0, $s1, 9
    srl $s5, $t0, 9 # $s5 = num2 mantissa
    srl $s0, $s0, 31 # $s0 = num1 sign
    srl $s1, $s1, 31 # $s1 = num2 sign
    blt	$s2, $s3, move_num_one
move_num_two: # $s2 >= $s3
    sub $t0, $s2, $s3
    srlv $s5, $s5, $t0
    move $s3, $s2
    j addition
move_num_one: # $s2 < $s3
    sub $t0, $s3, $s2
    srlv $s4, $s4, $t0
    move $s2, $s3
addition:
    bne $s0, $s1, diff_sign
diff_sign:
result:
    jr $ra
exit:
    lw $ra, 24($sp)
    lw $s5, 20($sp)
    lw $s4, 16($sp)
    lw $s3, 12($sp)
    lw $s2, 8($sp)
    lw $s1, 4($sp)
    lw $s0, 0($sp)
    addi $sp, $sp, 28
    li $v0, 10
    syscall