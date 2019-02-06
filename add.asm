# Tiange Wang Lab02. ID: 3717659
.data
    A: .float 12.0
    B: .float 12.0
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
    lw $a0, 0($t0) # num1 argument
    la $t1, B
    lw $a1, 0($t1) # num2 argument
    jal MYADD
    la $t2, C
    sw $v0, 0($t2) # $v0 = result
    j exit
MYADD:
    move $s0, $a0
    move $s1, $a1
    # exponents
    srl $t0, $s0, 23
    andi $s2, $t0, 0x00FF # $s2 = num1 exponent, final result exponent
    srl $t0, $s1, 23
    andi $s3, $t0, 0x00FF # $s3 = num2 exponent
    # mantissas
    li $t1, 0x00800000 # bit24 is 1
    sll $t0, $s0, 9
    srl $s4, $t0, 9 
    or $s4, $s4, $t1 # $s4 = num1 mantissa, final result mantissa, bit24 = hidden 1, bit25 = potential overflow
    sll $t0, $s1, 9
    srl $s5, $t0, 9 
    or $s5, $s5, $t1 # $s5 = num2 mantissa , bit24 = hidden 1, bit25 = potential overflow
    # signs
    srl $s0, $s0, 31 # $s0 = num1 sign, final result sign
    srl $s1, $s1, 31 # $s1 = num2 sign
    blt	$s2, $s3, move_num_one
move_num_two: # $s2 >= $s3
    sub $t0, $s2, $s3
    li $t1, 32
    sub $t1, $t1, $t0
    sllv $t2, $s5, $t1
    srlv $s5, $s5, $t0
    move $s3, $s2
    li $t3, 0x80000000
    and $t3, $t3, $t2 # $t3 = round bit
    li $t4, 0x7FFFFFFF
    and $t4, $t4, $t2 # $t4 = sticky bits
    beq $t3, $zero, addition
    beq $t4, $zero, addition
    addi $s5, $s5, 1
    j addition
move_num_one: # $s2 < $s3
    sub $t0, $s3, $s2
    li $t1, 32
    sub $t1, $t1, $t0
    sllv $t2, $s4, $t1
    srlv $s4, $s4, $t0
    move $s2, $s3
    li $t3, 0x80000000
    and $t3, $t3, $t2 # $t3 = round bit
    li $t4, 0x7FFFFFFF
    and $t4, $t4, $t2 # $t4 = sticky bits
    beq $t3, $zero, addition
    beq $t4, $zero, addition
    addi $s4, $s4, 1
addition:
    bne $s0, $s1, diff_sign
    add $s4, $s4, $s5
extra_bit_check:
    li $t0, 0x01000000 # check bit25
    and $t0, $s4, $t0
    bne $t0, $zero, incre_expo
    j loop
diff_sign:
    bgt $s4, $s5, num_one_big # num1 mantissa > num2 mantissa
    blt $s4, $s5, num_two_big # num1 mantissa < num2 mantissa
    li $v0, 0 # num1 mantissa = num2 mantissa
    jr $ra
num_one_big:
    sub $s4, $s4, $s5
    move $s1, $s0 # num1 sign dominate
    j extra_bit_check
num_two_big:
    sub $s4, $s5, $s4
    move $s0, $s1 # num2 sign dominate
    j extra_bit_check
incre_expo:
    srl $s4, $s4, 1
    li $t0, 0x00FE
    bge $s2, $t0, overflow
    addi $s2, $s2, 1 # adding 1 to the final result exponent
loop:
    li $t0, 0x00800000
    and $t0, $t0, $s4
    bne $t0, $zero, result
    beq $s4, $zero, result
    sll $s4, $s4, 1
    li $t0, 0x0001
    ble $s2, $t0, underflow
    addi $s2, $s2, -1
    j loop
overflow:
    li $s2, 0x00FF
    li $s4, 0
    j result
underflow:
    li $v0, 0
    jr $ra
result:
    move $t0, $s0
    sll $t0, $t0, 31
    move $t1, $s2
    sll $t1, $t1, 23
    or $t0, $t0, $t1
    move $t2, $s4
    sll $t2, $t2, 9
    srl $t2, $t2, 9
    or $t0, $t0, $t2
    move $v0, $t0
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