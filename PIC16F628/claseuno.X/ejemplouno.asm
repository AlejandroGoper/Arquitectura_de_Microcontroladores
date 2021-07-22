   
	org 0x00
	goto inicio
	org 0x05
inicio
	movlw	d'10'	; pongo el numero 10 en decimal en el registro w
	movwf	0x20
	movlw	d'5'
	addwf	0x20,0	; sumo el 10 con 5, el resultado en w
	
	nop
	nop
	
	end
    