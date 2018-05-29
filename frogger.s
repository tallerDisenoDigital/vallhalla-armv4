		AREA PROGRAM, CODE
        EXPORT __main
__main
		mov r0, #0x20000000
		b  game
		b  stop
	
game
		mov  r4, #0x20000000	; main address
		mov  r5, #0x0		    ; game counter
		bl   resetGame
		b    gameLoop

gameLoop
		ldr   r6, [r4, #0x24]
		ldr   r7, [r4, #0x18]
		mov   r0, r4
		cmp   r6, #0x0		; Player Lost
		beq   game
		cmp   r7, #0x0		; Player Won
		beq   game
		
		mov   r1, r5
		bl    moveCreep
		mov   r5, r0
		
		mov   r0, r4
		bl    movePlayer
		
		mov   r0, r4
		bl    checkGame
		
		bl    delay
		b     gameLoop

checkGame
		push  {lr}
		mov   r3, r0
		ldr   r1, [r3, #0x20]
		cmp   r1, #0x7
		bleq  checkLast
		cmpne r1, #0x0
		blhi  checkCollision
		moveq r0, #0x0
		mov   r1, r0
		cmp   r1, #0x1
		moveq r0, r3
		bleq  looseLife
		pop   {lr}
		mov   pc, lr

checkLast
		push  {lr}
		ldr   r1, [r0, #0x1c]
		mov   r2, #0x1
		lsl   r1, r2, r1
		ldr   r2, [r0, #0x18]
		and   r3, r2, r1 
		cmp   r3, #0x0
		blne  removeExit
		moveq r3, #0x1
		mov   r0, r3
		pop   {lr}
		mov   pc, lr

removeExit
		push {lr}
		sub  r2, r2, r1
		str  r2, [r0, #0x18]
		bl   resetFrog
		mov  r3, #0x0
		pop  {lr}
		mov  pc, lr
		
looseLife
		push {lr}
		ldr  r1, [r0, #0x24]
		sub  r1, r1, #0x0
		str  r1, [r0, #0x24]
		bl   resetFrog
		pop  {lr}
		mov  pc, lr

delay
		mov r0, #0x0
		mov r1, #0xd0000
		
delayLoop
		cmp   r0, r1
		addne r0, r0, #0x1
		bne   delayLoop
		mov   pc, lr
		
resetGame
		push {r4, lr}
		mov  r4, r0
		bl   resetPlayer
		mov  r0, r4
		bl   resetCreep
		pop  {r4, lr}
		mov  pc, lr
		
resetPlayer
		push {lr}
		mov  r1, #0x5
		str  r1, [r0, #0x24]
		mov  r1, #0x0
		str  r1, [r0, #0x28]
		bl   resetFrog
		pop  {lr}
		mov  pc, lr
		
resetFrog
		mov r1, #0x0
		str r1, [r0, #0x1c]
		mov r1, #0x7
		str r1, [r0, #0x20]
		mov pc, lr
	
	;	parameter 	: R0 - Truck Memory Array Address.
	;	description : Clear the trucks from the screen. Apply 0 to all the registers involved.	
resetCreep
		mov	 r1, #0x0
		b	 resetCreepLoop
	
resetCreepLoop
		cmp r1, #0x5
		bhi resetCreepReturn
		lsl	r2, r1, #0x2
		mov r3, #0x0
		str r3, [r0, r2]
		add r1, r1, #0x1
		b   resetCreepLoop

resetCreepReturn
		mov r3, #0x4924
		str r3, [r0, 0x18]
		mov pc, lr
		
		;	parameters : r0 - player address
movePlayer
		push  {r4, r5}
		mov   r4, r0
		ldr   r0, [r4, #0x1c]
		ldr   r1, [r4, #0x20]
		ldr   r5, [r4, #0x28]
		;	Left
		cmp   r5, #0x1
		cmpeq r0, #0x0
		subhi r0, r0, #0x1
		;	Right
		cmp   r5, #0x2
		cmpeq r0, #0xe
		addls r0, r0, #0x1
		;	Down
		cmp   r5, #0x3
		cmpeq r1, #0x0
		subhi r1, r1, #0x1
		;	Up
		cmp   r5, #0x4
		cmpeq r1, #0x6
		addls r1, r1, #0x1
		
		;str   r0, [r4, #0x1c]
		;str   r1, [r4, #0x20]
		;mov   r0, #0
		;str   r0, [r4, #0x28]
		pop   {r4, r5}
		mov   pc, lr
		
		;	parameters : r0 - game address
checkCollision
		push {r4, r5, r6, r7, r8}
		mov r4, r0
		ldr r5, [r0, #0x1c]
		ldr r6, [r0, #0x20]
		mov r7, #0x0
		mov r8, #0x0
		b   checkCollisionLoop
		
checkCollisionLoop
		cmp  r8, #0x1
		beq  checkCollisionReturn
		cmp  r7, r6
		bls  checkCollisionReturn
		lsl  r0, r5, #0x2
		ldr  r0, [r4, r0]
		mov  r1, #0x1
		lsl  r1, r1, r5
		and  r8, r0, r1
		add  r7, r7, #0x1
		b    checkCollisionLoop
		
checkCollisionReturn
		mov r8, r0
		pop {r4, r5, r6, r7, r8}
		mov pc, lr
		
	;	parameter 	: r0 - Truck Memory Array Address.
	;               : r1 - Move Counter
	;	description : Clear the trucks from the screen. Apply 0 to all the registers involved.	
moveCreep
		push {r4, r5, r6, r7, lr}
		mov  r4, r0
		mov  r5, r1
		mov  r6, #0x0
		b	 moveCreepLoop
		
moveCreepLoop
		cmp  r6, #0x5
		bhi  moveCreepReturn
		lsl  r7, r6, #0x2
		ldr  r0, [r4, r7]
		mov  r1, r5
		and  r2, r6, #0x1
		cmp  r2, #0x0
		bleq moveCreepLeft
		cmp  r2, #0x1
		bleq moveCreepRight
		str  r0, [r4, r7]
		add	 r6, r6, #0x1
		b 	 moveCreepLoop
		
moveCreepReturn
		add  r5, r5, #0x1
		cmp   r5, #0x8
		moveq r5, #0x0
		mov   r0, r5
		pop   {r4, r5, r6, r7, lr}
		mov   pc, lr
	
moveCreepLeft
		lsl   r0, r0, #0x1
		cmp   r1, #0x2
		addls r0, #0x1
		mov   r2, #0xffff
		and   r0, r0, r2
		mov   pc, lr
		
moveCreepRight
		lsr   r0, r0, #0x1
		cmp   r1, #0x2
		addls r0, #0x8000
		mov   pc, lr
		
stop    
		B stop ; stop program

        END