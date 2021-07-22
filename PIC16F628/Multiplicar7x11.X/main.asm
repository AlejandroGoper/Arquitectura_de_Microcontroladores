#INCLUDE "P16F628.inc"	
	
	org 0x00
	goto inicio
	org 0x05
inicio
	bcf	STATUS,0
	movlw	d'11'
	movwf	0x20	;numero original    7
	movwf	0x21	
	rlf	0x21,1	;11x2
	rlf	0x21,1	;11x4
	rlf	0x21,1	;11x8
	movf	0x20,0
	subwf	0x21,1	;11x7
	
	nop
	nop
	end