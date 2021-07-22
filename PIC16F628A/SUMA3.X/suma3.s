#include <xc.inc>

/*
    Este programa realiza una suma con el comando ADDWF
    Suma w a f y guardo el resultado en f
    Entiendase F como una localidad de memoria, en este caso escogi 0x20
    */

psect	absdata,abs,ovrld
	org	0x00
	goto	main
	org	0x05
psect	code
main:
	movlw	07	;Muevo el primer numero a W
	movwf	0x20	;Muevo el contenido de W a la localidad de memoria RAM 0x20
	movlw	15	;Muevo el numero decimal 15 a W y se pierde el anterior numero.
	addwf	0x20,f	;Realizo la suma del contenido de la localidad 0x20 (87) y el contenido de W (15)
			; y el resultado de esta suma se guarda en 0x20
	nop
	;addwf	0x20,w	;Descomentar esta instrucción si queremos que el resultado se guarde en W
			;Y comentar la linea 18
	END 
