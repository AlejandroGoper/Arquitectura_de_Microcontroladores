#INCLUDE    "P16F628.inc"
#DEFINE	    cont    0x20
#DEFINE	    lugar   0x04    ;FSR
    
	org 0x00
	goto inicio
	org 0x05
inicio	
	movlw	d'29'
	movwf	cont
	movlw	0x22
	movwf	FSR
bucle	
	movlw	d'18'
	movwf	INDF
	incf	FSR,1
	decfsz	cont,1
	goto	bucle
	
	nop
	
	end