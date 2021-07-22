P1N1	equ d'123'
P2N1	equ d'155'
P1N2	equ d'118'
P2N2	equ d'37'
	
	org 0x00
	goto inicio
	org 0x05
inicio
	movlw	P2N1
	movwf	0x21
	movlw	P1N1
	movwf	0x20
	movlw	P1N2
	bcf	0x03,2
	bcf	0x03,0
	subwf	0x20,0
	btfss	0x03,0
	goto	complemento
	movwf	0x24
	goto	continua	
complemento
	movwf	0x24
	comf	0x24,1
	incf	0x24,1
	decf	0x21,1
continua	
	bcf	0x03,2
	bcf	0x03,0
	movlw	P2N2
	subwf	0x21
	btfsc	0x03,0
	goto	termina
	movwf	0x25
	comf	0x25,1
	incf	0x25,1
termina
	nop
	end