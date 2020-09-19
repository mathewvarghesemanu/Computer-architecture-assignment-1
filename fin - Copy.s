.global _exit
.global _printf
.global _a

	.align 4
_a:
	.word 10
LC0:
	.ascii "Hi No.%d\12\0"

	.align 4
.global _main
_main:
	; Initialize Stack Pointer, set r14=0.
	; r0 always contains a 0 	and cannot be modified
	add r14,r0,r0
	lhi r14, ((memSize-4)>>16)&0xffff
	addui r14, r14, ((memSize-4)&0xffff)

	; Set r4=13
	add r4, r0, #13

	; Set r3=0
	add r3, r0, r0

	
_my_loop_in:
	
	;log operation
	srai r11,r4,#1
	add r4,r11,r0


	; If r4==0, jump out of this loop.
	; NOTE, for now, every instruction that could jump 
	; should be followed by a nop
	beqz r4, _show 
	nop

	add r3, r3, #1
	
_show:
	; The following lines make a function call to printf. 
	; They're equiavalent to "printf(LC0, r3)" in C.
	sub r14,r14,#8
	lhi r5,(LC0>>16)&0xffff
	addui r5,r5,(LC0&0xffff)
	sw 0(r14),r5
	sw 4(r14),r3
	jal _printf
	nop
	add r14,r14,#8
	
	; Jump back to the beginning of this loop
	; NOTE, for now, every instruction that could jump 
	; should be followed by a nop
	j _my_loop_out
	nop

_my_loop_out:

	; Exit the program 
	jal _exit
	nop

_exit:
	trap #0
	jr r31
	nop
_printf:
	trap #5
	jr r31
	nop
