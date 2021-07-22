#include <xc.inc>

/*
    Realizar la suma de 140 + 54 y guardar el resultado en la localidad de
     memoria 0x25
*/

psect	absdata,abs,ovrld
	org	0x00
	goto	main
	org	0x05
psect	code
main:
	movlw	140	;Muevo el primer numero a W
	movwf	0x20	;Muevo el contenido de W a la localidad de memoria RAM 0x20
	movlw	54	;Muevo el segundo numero a W y se pierde el anterior numero de W.
	addwf	0x20,w	;Realizo la suma del contenido de la localidad 0x20 (140) y el contenido de W (54)
			; y el resultado de esta suma se guarda en W
	movwf	0x25	;Muevo el contenido de W a la localidad deseada
	nop
	END 