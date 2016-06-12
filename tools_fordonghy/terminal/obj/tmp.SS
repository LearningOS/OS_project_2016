
tmp.o：     文件格式 elf32-tradlittlemips


Disassembly of section .text:

00000000 <_Main_New>:
   0:	afbe0000 	sw	s8,0(sp)
   4:	afbffffc 	sw	ra,-4(sp)
   8:	03a0f025 	move	s8,sp
   c:	27bdfff0 	addiu	sp,sp,-16

00000010 <_L17>:
  10:	24080004 	li	t0,4
  14:	afa80004 	sw	t0,4(sp)
  18:	0c000000 	jal	0 <_Main_New>
  1c:	00000000 	nop
  20:	00000000 	nop
  24:	00404025 	move	t0,v0
  28:	3c090000 	lui	t1,0x0
  2c:	25290000 	addiu	t1,t1,0
  30:	ad090000 	sw	t1,0(t0)
  34:	01001025 	move	v0,t0
  38:	03c0e825 	move	sp,s8
  3c:	8fdffffc 	lw	ra,-4(s8)
  40:	8fde0000 	lw	s8,0(s8)
  44:	03e00008 	jr	ra
  48:	00000000 	nop
  4c:	00000000 	nop

00000050 <_Fibonacci_New>:
  50:	afbe0000 	sw	s8,0(sp)
  54:	afbffffc 	sw	ra,-4(sp)
  58:	03a0f025 	move	s8,sp
  5c:	27bdfff0 	addiu	sp,sp,-16

00000060 <_L18>:
  60:	24080004 	li	t0,4
  64:	afa80004 	sw	t0,4(sp)
  68:	0c000000 	jal	0 <_Main_New>
  6c:	00000000 	nop
  70:	00000000 	nop
  74:	00404025 	move	t0,v0
  78:	3c090000 	lui	t1,0x0
  7c:	25290008 	addiu	t1,t1,8
  80:	ad090000 	sw	t1,0(t0)
  84:	01001025 	move	v0,t0
  88:	03c0e825 	move	sp,s8
  8c:	8fdffffc 	lw	ra,-4(s8)
  90:	8fde0000 	lw	s8,0(s8)
  94:	03e00008 	jr	ra
  98:	00000000 	nop
  9c:	00000000 	nop

000000a0 <main>:
  a0:	afbe0000 afbffffc 03a0f025 27bdffe4     ........%......'

000000b0 <_L19>:
  b0:	0c000014 	jal	50 <_Fibonacci_New>
  b4:	00000000 	nop
  b8:	00000000 	nop
  bc:	00404025 	move	t0,v0
  c0:	01004825 	move	t1,t0
  c4:	24080000 	li	t0,0
  c8:	01005025 	move	t2,t0
  cc:	afcafff8 	sw	t2,-8(s8)
  d0:	afc9fff4 	sw	t1,-12(s8)

000000d4 <_L20>:
  d4:	2408000a 	li	t0,10
  d8:	8fc9fff8 	lw	t1,-8(s8)
  dc:	0128502a 	slt	t2,t1,t0
  e0:	afc9fff8 	sw	t1,-8(s8)
  e4:	1140002a 	beqz	t2,190 <_L22>
  e8:	00000000 	nop
  ec:	00000000 	nop

000000f0 <_L21>:
  f0:	8fc8fff4 	lw	t0,-12(s8)
  f4:	afa80004 	sw	t0,4(sp)
  f8:	8fc9fff8 	lw	t1,-8(s8)
  fc:	afa90008 	sw	t1,8(sp)
 100:	8d0a0000 	lw	t2,0(t0)
 104:	8d4b0008 	lw	t3,8(t2)
 108:	afc9fff8 	sw	t1,-8(s8)
 10c:	afc8fff4 	sw	t0,-12(s8)
 110:	0160f809 	jalr	t3
 114:	00000000 	nop
 118:	00000000 	nop
 11c:	00405025 	move	t2,v0
 120:	8fc9fff8 	lw	t1,-8(s8)
 124:	8fc8fff4 	lw	t0,-12(s8)
 128:	afaa0004 	sw	t2,4(sp)
 12c:	afc9fff8 	sw	t1,-8(s8)
 130:	afc8fff4 	sw	t0,-12(s8)
 134:	0c000000 	jal	0 <_Main_New>
 138:	00000000 	nop
 13c:	00000000 	nop
 140:	8fc9fff8 	lw	t1,-8(s8)
 144:	8fc8fff4 	lw	t0,-12(s8)
 148:	3c0a0000 	lui	t2,0x0
 14c:	254a0014 	addiu	t2,t2,20
 150:	afaa0004 	sw	t2,4(sp)
 154:	afc9fff8 	sw	t1,-8(s8)
 158:	afc8fff4 	sw	t0,-12(s8)
 15c:	0c000000 	jal	0 <_Main_New>
 160:	00000000 	nop
 164:	00000000 	nop
 168:	8fc9fff8 	lw	t1,-8(s8)
 16c:	8fc8fff4 	lw	t0,-12(s8)
 170:	240a0001 	li	t2,1
 174:	012a5821 	addu	t3,t1,t2
 178:	01604825 	move	t1,t3
 17c:	afc9fff8 	sw	t1,-8(s8)
 180:	afc8fff4 	sw	t0,-12(s8)
 184:	1000ffd3 	b	d4 <_L20>
 188:	00000000 	nop
 18c:	00000000 	nop

00000190 <_L22>:
 190:	0c000000 	jal	0 <_Main_New>
 194:	00000000 	nop
 198:	00000000 	nop
 19c:	00404025 	move	t0,v0
 1a0:	01004825 	move	t1,t0
 1a4:	8fc8fff4 	lw	t0,-12(s8)
 1a8:	afa80004 	sw	t0,4(sp)
 1ac:	afa90008 	sw	t1,8(sp)
 1b0:	8d090000 	lw	t1,0(t0)
 1b4:	8d280008 	lw	t0,8(t1)
 1b8:	0100f809 	jalr	t0
 1bc:	00000000 	nop
 1c0:	00000000 	nop
 1c4:	00404825 	move	t1,v0
 1c8:	afa90004 	sw	t1,4(sp)
 1cc:	0c000000 	jal	0 <_Main_New>
 1d0:	00000000 	nop
 1d4:	00000000 	nop
 1d8:	3c080000 	lui	t0,0x0
 1dc:	25080014 	addiu	t0,t0,20
 1e0:	afa80004 	sw	t0,4(sp)
 1e4:	0c000000 	jal	0 <_Main_New>
 1e8:	00000000 	nop
 1ec:	00000000 	nop
 1f0:	24020000 	li	v0,0
 1f4:	03c0e825 	move	sp,s8
 1f8:	8fdffffc 	lw	ra,-4(s8)
 1fc:	8fde0000 	lw	s8,0(s8)
 200:	03e00008 	jr	ra
 204:	00000000 	nop
 208:	00000000 	nop

0000020c <_Fibonacci.get>:
 20c:	afbe0000 	sw	s8,0(sp)
 210:	afbffffc 	sw	ra,-4(sp)
 214:	03a0f025 	move	s8,sp
 218:	27bdffe8 	addiu	sp,sp,-24

0000021c <_L23>:
 21c:	24080002 	li	t0,2
 220:	8fc90008 	lw	t1,8(s8)
 224:	0128502a 	slt	t2,t1,t0
 228:	afc90008 	sw	t1,8(s8)
 22c:	1140000a 	beqz	t2,258 <_L25>
 230:	00000000 	nop
 234:	00000000 	nop

00000238 <_L24>:
 238:	24080001 	li	t0,1
 23c:	01001025 	move	v0,t0
 240:	03c0e825 	move	sp,s8
 244:	8fdffffc 	lw	ra,-4(s8)
 248:	8fde0000 	lw	s8,0(s8)
 24c:	03e00008 	jr	ra
 250:	00000000 	nop
 254:	00000000 	nop

00000258 <_L25>:
 258:	24080001 	li	t0,1
 25c:	8fc90008 	lw	t1,8(s8)
 260:	01285023 	subu	t2,t1,t0
 264:	8fc80004 	lw	t0,4(s8)
 268:	afa80004 	sw	t0,4(sp)
 26c:	afaa0008 	sw	t2,8(sp)
 270:	8d0a0000 	lw	t2,0(t0)
 274:	8d4b0008 	lw	t3,8(t2)
 278:	afc80004 	sw	t0,4(s8)
 27c:	afc90008 	sw	t1,8(s8)
 280:	0160f809 	jalr	t3
 284:	00000000 	nop
 288:	00000000 	nop
 28c:	00405025 	move	t2,v0
 290:	8fc80004 	lw	t0,4(s8)
 294:	8fc90008 	lw	t1,8(s8)
 298:	240b0002 	li	t3,2
 29c:	012b6023 	subu	t4,t1,t3
 2a0:	afa80004 	sw	t0,4(sp)
 2a4:	afac0008 	sw	t4,8(sp)
 2a8:	8d0b0000 	lw	t3,0(t0)
 2ac:	8d6c0008 	lw	t4,8(t3)
 2b0:	afc80004 	sw	t0,4(s8)
 2b4:	afcafff8 	sw	t2,-8(s8)
 2b8:	afc90008 	sw	t1,8(s8)
 2bc:	0180f809 	jalr	t4
 2c0:	00000000 	nop
 2c4:	00000000 	nop
 2c8:	00405825 	move	t3,v0
 2cc:	8fc80004 	lw	t0,4(s8)
 2d0:	8fcafff8 	lw	t2,-8(s8)
 2d4:	8fc90008 	lw	t1,8(s8)
 2d8:	014b6021 	addu	t4,t2,t3
 2dc:	afc80004 	sw	t0,4(s8)
 2e0:	afc90008 	sw	t1,8(s8)
 2e4:	01801025 	move	v0,t4
 2e8:	03c0e825 	move	sp,s8
 2ec:	8fdffffc 	lw	ra,-4(s8)
 2f0:	8fde0000 	lw	s8,0(s8)
 2f4:	03e00008 	jr	ra
 2f8:	00000000 	nop
 2fc:	00000000 	nop
