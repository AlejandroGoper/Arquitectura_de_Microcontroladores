	contador_1  equ	0x20
	contador_2  equ	0x21
	contador_3  equ	0x22
	contador    equ	0x25
	
	org 0x00
	goto inicio
	org 0x05
inicio
	movlw	d'2'
	call	retardo_x1ms
retardo_x1ms
	movwf	contador
	ciclo_1ms
	    movlw	d'2' ; 250
	    movwf	contador_1
	    ciclo1_1ms
		nop
		decfsz  contador_1,1
	    goto    ciclo1_1ms
	decfsz	contador,1
	goto	ciclo_1ms
	end
retardo_x10ms
	movwf	contador
	ciclo_10ms
	    movlw   d'10'
	    movwf   contador_1
	    ciclo1_10ms
		movlw	d'250'
		movwf	contador_2
		ciclo2_10ms
		    nop
		    decfsz  contador_2,1
		goto	ciclo2_10ms
		decfsz	contador_1,1
	    goto ciclo1_10ms
	    decfsz  contador,1
	goto	ciclo_10ms	  
	
retardo_x100ms
	movwf	contador
	ciclo_100ms
	    movlw   d'100'
	    movwf   contador_1
	    ciclo1_100ms
		movlw	d'250'
		movwf	contador_2
		ciclo2_100ms
		    nop
		    decfsz  contador_2,1
		goto	ciclo2_100ms
		decfsz	contador_1,1
	    goto ciclo1_100ms
	    decfsz  contador,1
	goto	ciclo_100ms	

retardo_x1s
	movwf	contador
	ciclo_1s
	    movlw   d'10'
	    movwf   contador_1
	    ciclo1_1s
		movlw	d'100'
		movwf	contador_2
		ciclo2_1s
		    movlw	d'250'
		    movwf	contador_3
		    ciclo3_1s
			nop
			decfsz	contador_3,1
		    goto    ciclo3_1s
		    decfsz  contador_2,1
		goto	ciclo2_1s
		decfsz	contador_1,1
	    goto    ciclo1_1s
	    decfsz	contador,1
	goto	ciclo_1s