		.h8300s
		
		.equ	PUTS,0x114
		.equ	GETS,0x113
		.equ	syscall,0x1FF00

		.data
vstup:	.space	100
prompt:	.asciz "Zadejte vstupni data: "

		.align	2
par_vstup:	.long	vstup
par_prompt:	.long	prompt
		
		.align 1
		.space	100
stck:

		.text
		.global	_start
		
prevod:	
		cmp #'A', R0L
		bhs prevod_pismeno
		add.b #-'0', R0L
		rts

prevod_pismeno:
		add.b #(-'A'+10), R0L
		rts
	
_start:	mov.l	#stck,ER7	
		mov.l	#vstup,ER2
		
		mov.w	#PUTS,R0
		mov.l	#par_prompt,ER1
		jsr		@syscall
		
		mov.w	#GETS,R0
		mov.l	#par_vstup,ER1
		jsr		@syscall
		
		
		xor.l	ER1,ER1
		
lab2:	mov.b	@ER2+,R0L
		cmp.b	#0x0A,R0L
		beq		lab3
		jsr		@prevod
		
		rotl.l	#2,ER1
		rotl.l	#2,ER1
		or.b	R0L,R1L
		
		jmp		@lab2	
		
lab3:	
		mov.l #vstup, ER2
		mov.w #10, R3
cyklus:
		cmp.l #0, ER1
		beq otocit
		
		divxu R3, ER1
		
		mov.w E1, R4
		add.b #'0', R4L
		mov.b R4L, @ER2
		inc.l #1, ER2
		
		xor.w E1, E1
		
		jmp @cyklus

otocit:
	mov ER2, ER1
	
	inc.l #1, ER2
	mov.b #0, R0L
	mov.b R0L, @ER2
	
	dec.l #1, ER1
	mov #vstup, ER2
	
cyklus2:
	cmp.l ER1, ER2
	bhs vypis
	
	mov @ER2, R0L
	mov @ER1, R0H
	
	mov R0L, @ER1
	mov R0H, @ER2
	
	dec.l #1, ER1
	inc.l #1, ER2
	
	jmp @cyklus2
	
vypis:
		mov.w	#PUTS,R0
		mov.l	#par_vstup,ER1
		jsr		@syscall

konec:
jmp		@konec
