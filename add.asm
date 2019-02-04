# Tiange Wang Lab02. ID: 3717659
.data
    A: .float 12.5
    B: .float 3.5
    C: .float 0.0
.text
main:
    la $t0, A
    lw $a0, 0($t0)
    la $t1, B
    lw $a1, 0($t1)
    j MYADD
    la $t2, C
    sw $v0, 0($t2)
    li $v0, 10
    syscall
MYADD:
    move $t0, $a0 # $t0 = num1
    move $t1, $a1 # $t1 = num2

