#INCLUDE "P16F628.inc"	
	
	org 0x00
	goto inicio
	org 0x05
inicio
	bcf	STATUS,0
	movlw	d'28'
	movwf	0x20	;numero original    28
	movwf	0x21	
	rrf	0x21,1	;28/2
	rrf	0x21,1	;28/4
	
	nop
	nop
	end