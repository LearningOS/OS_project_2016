
#include <asm/mipsregs.h>

.global test_flash

.extern edata
.extern end

.set noreorder

.section .startup

#define KSTACKSIZE (4096*2)

test_flash:
	nop
	nop
	nop
	nop
	nop

	li $v0,0x80400000
	li $v1,0x11111111
	sw $v1,0($v0)
	sw $v1,4($v0)
	sw $v1,8($v0)
	sw $v1,12($v0)

	li $v1,0x33332222
	sh $v1,0($v0)
	sh $v1,2($v0)
	sh $v1,4($v0)
	sh $v1,6($v0)


	nop
	nop
	nop
	nop
	nop
	

# 	li $v0,0xbe000000
# 	li $v1,0x20
# 	sw $v1,0($v0)

# t1:
# 	li $v1,0xff
# 	blez $v1,t1
# 	nop

# 	li $v1,0xd0
# 	sw $v1,0($v0)

# t2:
# 	li $v1,0xff
# 	blez $v1,t2
# 	nop

# l1:
# 	lw $v1,0($v0)
# 	andi $v1,$v1,0x80
# 	blez $v1,l1
# 	nop

# 	li $v1,0x40
# 	sw $v1,0($v0)
# 	li $v1,0xab
# 	sw $v1,0($v0)

# l2:
# 	lw $v1,0($v0)
# 	andi $v1,$v1,0x80
# 	blez $v1,l2
# 	nop


# 	nop
# 	nop
# 	nop
# 	nop
# 	nop


# 	li $v0,0xbe000000
# 	li $v1,0x20
# 	sh $v1,0($v0)
# 	li $v1,0xd0
# 	sh $v1,0($v0)

# l3:
# 	lhu $v1,0($v0)
# 	andi $v1,$v1,0x80
# 	blez $v1,l3
# 	nop

# 	li $v1,0x40
# 	sh $v1,0($v0)
# 	li $v1,0xab
# 	sh $v1,0($v0)

# l4:
# 	lhu $v1,0($v0)
# 	andi $v1,$v1,0x80
# 	blez $v1,l4
# 	nop
