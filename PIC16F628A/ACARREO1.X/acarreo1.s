#include <xc.inc>

/*
Este programa es para ejemplificar la suma de dos numeros de 16 bits
teniendo en cuenta el concepto de acarreo, en el registro STATUS (localidad 0x03)
en el bit 0 (llamado carry o simplemente C)
	
El programa sumara 300d + 180d = 480d
o bien, 200d + 100d + 180d = 480d

    */

psect	absdata,abs,ovrld
	org	0x00
	goto	main
	org	0x05
psect	code
main:
	movlw	200	; movemos 200 a W
	movwf	0x20	; cargo el 200 a localidad 0x20
	movlw	100	; cargo 100 a W
	movwf	0x21	; cargo 100 a localidad 0x21
	movlw	180	; cargo 180 a W
	movwf	0x22	; cargo 180 a localidad 0x22
	bcf	STATUS,0    ; BCF -- bit clear file, pone a 0 un bit de un registro de memoria seleccionada
;	bcf	0x03,0	; Si no queremos usar etiquetas para las localidades podemos poner esta isntrucción
	addwf	0x21,W	; sumo W (180) con localidad 0x21 (100) y lo dejo en W que ahora tiene 280
	movwf	0x23	; guardamos el resultado, pasamos W (280) a localidad 0x23
	nop
	END