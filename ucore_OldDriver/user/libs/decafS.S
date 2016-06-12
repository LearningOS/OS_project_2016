.extern printInt
.extern printBool
.extern printStr
.extern alloc

.set noreorder

.text

.globl _Div
.type _Div, @function
_Div:
	#v0 yong lai fang fu hao xin xi
	#v1 yong lai zuo zan shi ji cun qi
	#a2 shi chu shu
	#a1 shi bei chu shu di wei, tong shi cun fang shang
	#a0 shi bei chu shu gao wei, tong shi cun fang yu shu
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	li $a0, 0

	li $a3, 32
	srl $v0, $a1, 31
	beq $v0, $zero, _Div_p1
	nop

	nor $a1, $a1, $zero
	addiu $a1, $a1, 1

_Div_p1:
	srl $v1, $a2, 31
	xor $v0, $v0, $v1
	beq $v1, $zero, _Div_loop
	nop

	nor $a2, $a2, $zero
	addiu $a2, $a2, 1

_Div_loop:
	srl $v1, $a1, 31
	sll $a0, $a0, 1
	sll $a1, $a1, 1
	addu $a0, $v1, $a0

	subu $v1, $a0, $a2
	bltz $v1, _Div_p
	nop
	move $a0, $v1
	addiu $a1, $a1, 1


_Div_p:
	addiu $a3, $a3, -1
	bne $a3, $zero, _Div_loop
	nop

	beq $v0, $zero, _Div_res_p
	nop
	nor $a1, $a1, $zero
	addiu $a1, $a1, 1

_Div_res_p:
	move $v0, $a1
	jr $ra
	nop


.globl _Mod
.type _Mod, @function
_Mod:
	#v0 yong lai fang fu hao xin xi
	#v1 yong lai zuo zan shi ji cun qi
	#a2 shi chu shu
	#a1 shi bei chu shu di wei, tong shi cun fang shang
	#a0 shi bei chu shu gao wei, tong shi cun fang yu shu
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	li $a0, 0

	li $a3, 32
	srl $v0, $a1, 31
	beq $v0, $zero, _Mod_p1
	nop

	nor $a1, $a1, $zero
	addiu $a1, $a1, 1

_Mod_p1:
	srl $v1, $a2, 31
	beq $v1, $zero, _Mod_loop
	nop

	nor $a2, $a2, $zero
	addiu $a2, $a2, 1

_Mod_loop:
	srl $v1, $a1, 31
	sll $a0, $a0, 1
	sll $a1, $a1, 1
	addu $a0, $v1, $a0

	subu $v1, $a0, $a2
	bltz $v1, _Mod_p
	nop
	move $a0, $v1
	addiu $a1, $a1, 1


_Mod_p:
	addiu $a3, $a3, -1
	bne $a3, $zero, _Mod_loop
	nop

	beq $v0, $zero, _Mod_res_p
	nop
	nor $a0, $a0, $zero
	addiu $a0, $a0, 1

_Mod_res_p:
	move $v0, $a0
	jr $ra
	nop


.globl _PrintBool
.type _PrintBool,@function
_PrintBool:
	sw $fp, 0($sp)
	lw $a0, 4($sp)
    sw $ra, -4($sp)
    move $fp, $sp
    addiu $sp, $sp, -16

    jal printBool
    nop

    li $v0, 0
    move  $sp, $fp
    lw    $ra, -4($fp)
    lw    $fp, 0($fp)
    jr    $ra
    nop


.globl _PrintInt
.type _PrintInt,@function
_PrintInt:
	sw $fp, 0($sp)
	lw $a0, 4($sp)
    sw $ra, -4($sp)
    move $fp, $sp
    addiu $sp, $sp, -16

    jal printInt
    nop

    li $v0, 0
    move  $sp, $fp
    lw    $ra, -4($fp)
    lw    $fp, 0($fp)
    jr    $ra
    nop


.globl _PrintString
.type _PrintString, @function
_PrintString:
	sw $fp, 0($sp)
	lw $a0, 4($sp)
    sw $ra, -4($sp)
    move $fp, $sp
    addiu $sp, $sp, -16

    jal printStr
    nop

    li $v0, 0
    move  $sp, $fp
    lw    $ra, -4($fp)
    lw    $fp, 0($fp)
    jr    $ra
    nop


.globl _Alloc
.type _Alloc, @function
_Alloc:
	sw $fp, 0($sp)
	lw $a0, 4($sp)
    sw $ra, -4($sp)
    move $fp, $sp
    addiu $sp, $sp, -16

    jal alloc
    nop


    move  $sp, $fp
    lw    $ra, -4($fp)
    lw    $fp, 0($fp)
    jr    $ra
    nop

.globl _Halt
_Halt:
    li $v0,129
    syscall
    nop


.data
_STRING1:
          .asciiz "Main\n"