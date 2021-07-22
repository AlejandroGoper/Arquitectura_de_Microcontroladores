numA	equ d'8'
numB	equ d'1'
	
	org 0x00
	goto inicio
	org 0x05
inicio
	movlw	numA
	sublw	numB	; numB - numA
	movwf	0x20
	comf	0x20,1	
	incf	0x20,1
	nop
	
	end