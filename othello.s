	.equ SWI_Exit, 0x11
	.text
	mov r3, #0
	mov r0, #0
	mov r1, #0
	mov r8, #0
	mov r9, #0
	mov r7, #1
	mov r5, #8
	ldr r6, =Array

Initialise1:
	ldr r3,=DD
	mov r4,#60
	str r4,[r3]
	mov r4,#2
	str r4,[r3,#4]
	str r4,[r3,#8]
	mov r3, #0

Initialise:
	strb r0, [r6,r3]
	add r3, r3, #1
	cmp r3, #64
	blt Initialise
	beq PutChips

PutChips:
	mov r3, #1
	strb r3,[r6,#27]
	strb r3,[r6,#36]
	mov r3, #2
	strb r3,[r6,#28]
	strb r3,[r6,#35]

Manny:
	bl Print
	ldr r3,=EE
	mov r4,#0
	strb r4,[r3,#2]
	strb r4,[r3,#1]
	mov r11,#1
	ldr r3,=DD
	ldr r4,[r3]
	cmp r4,#0
	beq Endd
	ldr r4,[r3,#4]
	cmp r4,#0
	beq Endd
	ldr r4,[r3,#8]
	cmp r4,#0
	beq Endd
	b All_Check

Manny2:
	mov r11,#0
	cmp r7,#1
	moveq r7,#2
	beq White_move1
	movne r7,#1
	bne Black_move1
	
Print:
	mov r0,#0
	mov r1,#0
	ldr r6, =Array

Pr_Loop:
	ldrb r2,[r6]
	swi 0x205
	add r6,r6,#1
	add r0,r0,#2
	cmp r0,#16
	blt Pr_Loop
	mov r0,#0
	add r1,r1,#1
	cmp r1,#8
	blt Pr_Loop
	ldr r2,=Message1
	mov r0,#0
	mov r1,#9
	swi 0x204
	mov r1,#11
	ldr r2,=Message2
	swi 0x204
	ldr r3,=DD
	add r3,r3,#4
	ldr r2,[r3]
	mov r0,#9
	mov r1,#9
	swi 0x205
	add r3,r3,#4
	ldr r2,[r3]
	add r1,r1,#2
	swi 0x205
	mov pc,lr
	

White_move1:
	mov r0,#18
	mov r1,#4
	ldr r2,=Message8
	swi 0x204
	ldr r3,=CC
	mov r4,#0
	strb r4,[r3,#2]
	mov r0,#0x02
	swi 0x201
	swi 0x203
	cmp r0, #0
	beq White_move1
	bl Log
	mov r8, r0
	b White_move2

Log:
	cmp r0, #1
	subeq r0, r0, #1
	cmp r0, #2
	subeq r0, r0, #1
	cmp r0, #4
	subeq r0, r0, #2
	cmp r0, #8
	subeq r0, r0, #5
	cmp r0, #16
	subeq r0, r0, #12
	cmp r0, #32
	subeq r0, r0, #27
	cmp r0, #64
	subeq r0, r0, #58
	cmp r0, #128
	subeq r0, r0, #121
	mov pc,lr

White_move2:
	mov r0,#18
	mov r1,#4
	ldr r2,=Message8
	swi 0x204
	mov r0,#0x01
	swi 0x201
	swi 0x203
	cmp r0, #0
	beq White_move2
	bl Log
	mov r9, r0
	mov r7, #2
	mov r11,#0
	swi 0x208
	bl Print
	b Check_move
	
Black_move1:
	mov r0,#18
	mov r1,#4
	ldr r2,=Message7
	swi 0x204
	ldr r3,=CC
	mov r4,#0
	strb r4,[r3,#1]
	mov r0,#0x02
	swi 0x201
	swi 0x203
	cmp r0, #0
	beq Black_move1
	bl Log
	mov r8, r0
	b Black_move2

Black_move2:
	mov r0,#18
	mov r1,#4
	ldr r2,=Message7
	swi 0x204
	mov r0,#0x01
	swi 0x201
	swi 0x203
	cmp r0, #0
	beq Black_move2
	bl Log
	mov r9, r0
	mov r7, #1
	mov r11,#0
	mov r0, #2
	swi 0x208
	bl Print
	b Check_move

Check_move:
	bl Check_north

All_Check:
	mov r8,#0
	mov r9,#0
	ldr r6,=Array

Loop_All_Check:
	bl Check_north

Line:
	add r9,r9,#1
	cmp r9,#8
	blt Loop_All_Check
	mov r9,#0
	add r8,r8,#1
	cmp r8,#8
	blt Loop_All_Check

Check_north:
	ldr r6,=Array
	cmp r8,#0
	beq Check_south
	mov r3,r8
	sub r3,r3,#1
	mov r5,#8	
	mla r10,r3,r5,r9
	add r6,r6,r10
	ldrb r4,[r6]
	cmp r4,r7
	beq Check_south

Loop_check_north:	
	ldrb r4,[r6]
	cmp r4,#0
	beq Check_south
	cmp r4,r7
	beq Check_r_north
	sub r3,r3,#1
	sub r6,r6,r5
	cmp r3,#0
	bgt Loop_check_north
	b Check_south

Check_r_north:
	ldr r10, =Array
	add r6,r6,#8
	mla r10,r8,r5,r10
	add r10,r10,r9
	cmp r11,#0
	beq Change_north1
	bne Just_Check
	b Check_south

Just_Check:
	cmp r11,#1
	beq Manny2
	mov r4,#1
	ldr r3,=EE
	str r4,[r3,r7,lsl#2]
	b Manny2

Change_north1:
	ldr r3,=CC
	mov r4,#1
	strb r4,[r3,r7]
	ldr r3,=DD
	b Change_north

Change_north:
	cmp r7,#1
	moveq r5,#2
	movne r5,#1
	ldr r4,[r3,r5,lsl#2]
	sub r4,r4,#1
	str r4,[r3,r5,lsl#2]
	ldr r4,[r3,r7,lsl#2]
	add r4,r4,#1
	str r4,[r3,r7,lsl#2]
	strb r7,[r6]
	add r6,r6,#8
	mov r5,#8
	cmp r6,r10
	blt Change_north
	b Check_south

Check_south:
	ldr r6,=Array
	cmp r8,#7
	beq Check_west
	mov r3,r8
	add r3,r3,#1
	mla r10,r3,r5,r9
	add r6,r6,r10
	ldrb r4,[r6]
	cmp r4,r7
	beq Check_west

Loop_check_south:
	ldrb r4,[r6]
	cmp r4,#0
	beq Check_west
	cmp r4,r7
	beq Check_r_south
	add r3,r3,#1
	add r6,r6,r5
	cmp r3,r5
	blt Loop_check_south
	b Check_west

Check_r_south:
	ldr r10, =Array
	mla r10,r8,r5,r10
	add r10,r10,r9
	sub r6,r6,#8
	cmp r11,#0
	beq Change_south1
	bne Just_Check
	b Check_west

Change_south1:
	ldr r3,=CC
	mov r4,#1
	strb r4,[r3,r7]
	ldr r3,=DD
	b Change_south

Change_south:
	cmp r7,#1
	moveq r5,#2
	movne r5,#1
	ldr r4,[r3,r5,lsl#2]
	sub r4,r4,#1
	str r4,[r3,r5,lsl#2]
	ldr r4,[r3,r7,lsl#2]
	add r4,r4,#1
	str r4,[r3,r7,lsl#2]
	strb r7,[r6]
	sub r6,r6,#8
	mov r5,#8
	cmp r6,r10
	bgt Change_south
	b Check_west

Check_west:
	ldr r6,=Array
	cmp r9,#0
	beq Check_east
	mov r3,r9
	sub r3,r3,#1
	mla r10,r8,r5,r3
	add r6,r6,r10
	ldrb r4,[r6]
	cmp r4,r7
	beq Check_east

Loop_check_west:	
	ldrb r4,[r6]
	cmp r4,#0
	beq Check_east
	cmp r4,r7
	beq Check_r_west
	sub r3,r3,#1
	sub r6,r6,#1
	cmp r3,#0
	bge Loop_check_west
	b Check_east

Check_r_west:
	ldr r10, =Array
	add r6,r6,#1
	mla r10,r8,r5,r10
	add r10,r10,r9
	cmp r11,#0
	beq Change_west1
	bne Just_Check
	b Check_east

Change_west1:
	ldr r3,=CC
	mov r4,#1
	strb r4,[r3,r7]
	ldr r3,=DD
	b Change_west

Change_west:
	cmp r7,#1
	moveq r5,#2
	movne r5,#1
	ldr r4,[r3,r5,lsl#2]
	sub r4,r4,#1
	str r4,[r3,r5,lsl#2]
	ldr r4,[r3,r7,lsl#2]
	add r4,r4,#1
	str r4,[r3,r7,lsl#2]
	strb r7,[r6]
	add r6,r6,#1
	mov r5,#8
	cmp r6,r10	
	blt Change_west
	b Check_east

Check_east:
	ldr r6,=Array
	cmp r9,#7
	beq Check_north_west
	mov r3,r9
	add r3,r3,#1
	mla r10,r8,r5,r3
	add r6,r6,r10
	ldrb r4,[r6]
	cmp r4,r7
	beq Check_north_west

Loop_check_east:
	ldrb r4,[r6]
	cmp r4,#0
	beq Check_north_west
	cmp r4,r7
	beq Check_r_east
	add r3,r3,#1
	add r6,r6,#1
	cmp r3,r5
	blt Loop_check_east
	b Check_north_west

Check_r_east:
	ldr r10, =Array
	mla r10,r8,r5,r10
	add r10,r10,r9
	sub r6,r6,#1
	cmp r11,#0
	beq Change_east1
	bne Just_Check
	b Check_north_west

Change_east1:
	ldr r3,=CC
	mov r4,#1
	strb r4,[r3,r7]
	ldr r3,=DD
	b Change_east

Change_east:
	cmp r7,#1
	moveq r5,#2
	movne r5,#1
	ldr r4,[r3,r5,lsl#2]
	sub r4,r4,#1
	str r4,[r3,r5,lsl#2]
	ldr r4,[r3,r7,lsl#2]
	add r4,r4,#1
	str r4,[r3,r7,lsl#2]
	strb r7,[r6]
	sub r6,r6,#1
	mov r5,#8
	cmp r6,r10
	bgt Change_east
	b Check_north_west

Mmm1:
	mov r12,r8
	b Loop_north_west

Check_north_west:
	cmp r8,#0
	beq Check_south_west
	cmp r9,#0
	beq Check_south_west
	mov r3,#1
	ldr r10, =Array
	mla r10,r8,r5,r10
	add r10,r10,r9
	mov r6,r10
	sub r6,r6,#9
	ldrb r4,[r6]
	cmp r4,r7
	beq Check_south_west
	mov r12,r9
	cmp r8,r9
	blt Mmm1

Loop_north_west:
	ldrb r4,[r6]
	cmp r4,#0
	beq Check_south_west
	cmp r4,r7
	beq Check_r_north_west
	add r3,r3,#1
	sub r6,r6,#9
	cmp r3,r12
	blt Loop_north_west
	b Check_south_west

Check_r_north_west:
	add r6,r6,#9
	cmp r11,#0
	beq Change_north_west1
	bne Just_Check
	b Check_south_west

Change_north_west1:
	ldr r3,=CC
	mov r4,#1
	strb r4,[r3,r7]
	ldr r3,=DD
	b Change_north_west

Change_north_west:
	cmp r7,#1
	moveq r5,#2
	movne r5,#1
	ldr r4,[r3,r5,lsl#2]
	sub r4,r4,#1
	str r4,[r3,r5,lsl#2]
	ldr r4,[r3,r7,lsl#2]
	add r4,r4,#1
	str r4,[r3,r7,lsl#2]
	strb r7,[r6]
	add r6,r6,#9
	mov r5,#8
	cmp r6,r10
	blt Change_north_west
	b Check_south_west

Mmm2:
	mov r12,r9
	b Loop_south_west

Check_south_west:
	cmp r8,#7
	beq Check_north_east
	cmp r9,#0
	beq Check_north_east
	mov r3,#1
	ldr r10, =Array
	mla r10,r8,r5,r10
	add r10,r10,r9
	mov r6,r10
	add r6,r6,#7
	ldrb r4,[r6]
	cmp r4,r7
	beq Check_north_east
	mov r12,r8
	rsb r12,r12,#7
	cmp r9,r12
	blt Mmm2

Loop_south_west:
	ldrb r4,[r6]
	cmp r4,#0
	beq Check_north_east
	cmp r4,r7
	beq Check_r_south_west
	add r3,r3,#1
	add r6,r6,#7
	cmp r3,r12
	blt Loop_south_west
	b Check_north_east

Check_r_south_west:
	sub r6,r6,#7
	cmp r11,#0
	beq Change_south_west1
	bne Just_Check
	b Check_north_east

Change_south_west1:
	ldr r3,=CC
	mov r4,#1
	strb r4,[r3,r7]
	ldr r3,=DD
	b Change_south_west

Change_south_west:
	cmp r7,#1
	moveq r5,#2
	movne r5,#1
	ldr r4,[r3,r5,lsl#2]
	sub r4,r4,#1
	str r4,[r3,r5,lsl#2]
	ldr r4,[r3,r7,lsl#2]
	add r4,r4,#1
	str r4,[r3,r7,lsl#2]
	strb r7,[r6]
	sub r6,r6,#7
	mov r5,#8
	cmp r6,r10
	bgt Change_south_west
	b Check_north_east

Mmm3:
	mov r12,r8
	b Loop_north_east

Check_north_east:
	cmp r8,#0
	beq Check_south_east
	cmp r9,#7
	beq Check_south_east
	mov r3,#1
	ldr r10, =Array
	mla r10,r8,r5,r10
	add r10,r10,r9
	mov r6,r10
	sub r6,r6,#7
	ldrb r4,[r6]
	cmp r4,r7
	beq Check_south_east
	mov r12,r9
	rsb r12,r12,#7
	cmp r8,r12
	blt Mmm3

Loop_north_east:
	ldrb r4,[r6]
	cmp r4,#0
	beq Check_south_east
	cmp r4,r7
	beq Check_r_north_east
	add r3,r3,#1
	sub r6,r6,#7
	cmp r3,r12
	blt Loop_north_east
	b Check_south_east

Check_r_north_east:
	add r6,r6,#7
	cmp r11,#0
	beq Change_north_east1
	bne Just_Check

Change_north_east1:
	ldr r3,=CC
	mov r4,#1
	strb r4,[r3,r7]
	ldr r3,=DD
	b Change_north_east

Change_north_east:
	cmp r7,#1
	moveq r5,#2
	movne r5,#1
	ldr r4,[r3,r5,lsl#2]
	sub r4,r4,#1
	str r4,[r3,r5,lsl#2]
	ldr r4,[r3,r7,lsl#2]
	add r4,r4,#1
	str r4,[r3,r7,lsl#2]
	strb r7,[r6]
	add r6,r6,#7
	mov r5,#8
	cmp r6,r10
	blt Change_north_east
	b Check_south_east

Mmm4:
	mov r12,r5
	mov r5,#8
	b Loop_south_east

Check_south_east:
	cmp r8,#7
	beq Check_out
	cmp r9,#7
	beq Check_out
	mov r3,#1
	ldr r10, =Array
	mla r10,r8,r5,r10
	add r10,r10,r9
	mov r6,r10
	add r6,r6,#9
	ldrb r4,[r6]
	cmp r4,r7
	beq Check_out
	mov r12,r8
	rsb r12,r12,#7
	mov r5,r9
	rsb r5,r5,#7
	cmp r5,r12
	blt Mmm4
	mov r5,#8
Loop_south_east:
	ldrb r4,[r6]
	cmp r4,#0
	beq Check_out
	cmp r4,r7
	beq Check_r_south_east
	add r3,r3,#1
	add r6,r6,#9
	cmp r3,r12
	blt Loop_south_east
	b Check_out

Check_r_south_east:
	sub r6,r6,#9
	cmp r11,#0
	beq Change_south_east1
	bne Just_Check
	b Check_out

Change_south_east1:
	ldr r3,=CC
	mov r4,#1
	strb r4,[r3,r7]
	ldr r3,=DD
	b Change_south_east

Change_south_east:
	cmp r7,#1
	moveq r5,#2
	movne r5,#1
	ldr r4,[r3,r5,lsl#2]
	sub r4,r4,#1
	str r4,[r3,r5,lsl#2]
	ldr r4,[r3,r7,lsl#2]
	add r4,r4,#1
	str r4,[r3,r7,lsl#2]
	strb r7,[r6]
	sub r6,r6,#9
	mov r5,#8
	cmp r6,r10
	bgt Change_south_east

Check_out:
	cmp r11,#1
	beq Check_EE
	ldr r3, =CC
	ldrb r4,[r3,r7]
	cmp r4,#1
	bne Again
	strb r7,[r10]
	ldr r3,=DD
	cmp r7,#1
	ldr r4,[r3,r7,lsl#2]
	add r4,r4,#1
	str r4,[r3,r7,lsl#2]
	ldr r4,[r3]
	sub r4,r4,#1
	str r4,[r3]
	mov r5,#8
	b Manny

Check_EE:
	cmp r8,#7
	bne Line
	cmp r9,#7
	bne Line
	b Endd

Again:
	mov r0,#18
	mov r1,#2
	ldr r2,=Message6
	swi 0x204
	cmp r7,#1
	moveq r7,#2
	movne r7,#1
	b Manny

Endd:
	bl Print
	ldr r3,=DD
	ldr r4,[r3,#4]
	ldr r5,[r3,#8]
	ldr r2,=Message5
	cmp r4,r5
	ldrgt r2,=Message3
	ldrlt r2,=Message4
	mov r0,#0
	mov r1,#13
	swi 0x204

Ex:
	swi SWI_Exit

	.data
	Array: .space 400
	CC: .space 100 
	DD: .space 100
	EE: .space 100
	SPACE: .asciz " "
	Message1: .asciz "Blacks: "
	Message2: .asciz "Whites: "
	Message3: .asciz "Congrats!  Black wins"
	Message4: .asciz "Congrats!  White wins"
	Message5: .asciz "Match draw!"
	Message6: .asciz "Illegal Move!!!"
	Message7: .asciz "Black's(1) turn"
	Message8: .asciz "White's(2) turn"
.end