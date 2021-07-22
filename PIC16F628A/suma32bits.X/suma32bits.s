#include <xc.inc>
/*
    Este programa realiza la suma de dos numeros de 32bits
    
    */
    
    
; CONFIG
  CONFIG  FOSC = INTOSCCLK      ; Oscillator Selection bits (INTOSC oscillator: CLKOUT function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled)
  CONFIG  PWRTE = ON            ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  MCLRE = OFF           ; RA5/MCLR/VPP Pin Function Select bit (RA5/MCLR/VPP pin function is digital input, MCLR internally tied to VDD)
  CONFIG  BOREN = ON            ; Brown-out Detect Enable bit (BOD enabled)
  CONFIG  LVP = OFF             ; Low-Voltage Programming Enable bit (RB4/PGM pin has digital I/O function, HV on MCLR must be used for programming)
  CONFIG  CPD = OFF             ; Data EE Memory Code Protection bit (Data memory code protection off)
  CONFIG  CP = OFF              ; Flash Program Memory Code Protection bit (Code protection off)

psect	absdata,abs,ovrld
	org	0x00
	goto	main
	org	0x05
psect	code
main:	
	//Limpiando localidades a utilizar
	clrf	0x20	;Parte 1 A
	clrf	0x21	;Parte 2 A
	clrf	0x22	;Parte 3 A
	clrf	0x23	;Parte 4 A
	clrf	0x24	;Parte 1 B
	clrf	0x25	;Parte 2 B
	clrf	0x26	;Parte 3 B
	clrf	0x27	;Parte 4 B
	clrf	0x28	;Parte 1 R	
	clrf	0x29	;Parte 2 R
	clrf	0x2a	;Parte 3 R
	clrf	0x2b	;Parte 4 R
	clrf	0x2c	;Parte 5 R
	//Guardando las partes de los numeros de 16 bits
        movlw	11101111B   ;Muevo Parte 1 del numero A de 32 bits a w
	movwf	0x20	    ;Lo guardo en la localidad 0x20
	movlw	10101010B   ;Muevo Parte 2 del numero A de 32 bits a w
	movwf	0x21	    ;Lo guardo en la localidad 0x21
	movlw	00110000B   ;Muevo Parte 3 del numero A de 32 bits a w
	movwf	0x22	    ;Lo guardo en la localidad 0x22
	movlw	10111001B   ;Muevo Parte 4 del numero A de 32 bits a w
	movwf	0x23	    ;Lo guardo en la localidad 0x23
	movlw	10010011B   ;Muevo Parte 1 del numero B de 32 bits a w
	movwf	0x24	    ;Lo guardo en la localidad 0x24
	movlw	01111000B   ;Muevo Parte 2 del numero B de 32 bits a w
	movwf	0x25	    ;Lo guardo en la localidad 0x25
	movlw	10101011B   ;Muevo Parte 3 del numero B de 32 bits a w
	movwf	0x26	    ;Lo guardo en la localidad 0x26
	movlw	01100001B   ;Muevo Parte 4 del numero B de 32 bits a w
	movwf	0x27	    ;Lo guardo en la localidad 0x27
	bcf	STATUS,0    ;Limpio o pongo en 0 el bit o bandera de acarreo del registro status
	//Sumando las partes 1 de B y A
	movf	0x24,W	    ;Muevo el contenido de la localidad 0x22 (Parte 1 de B) a W para hacer la suma
	addwf	0x20,W	    ;Sumo los contenidos de W con 0x20 (Parte 1 de A) y los dejo en W
	movwf	0x28	    ;Guardamos el resultado de la suma de las partes bajas de A y B en 0x28
	//Verificando si hubo acarreo entre las partes 1 (que la suma haya excedido los 8 bits)
	btfsc	STATUS,0    ;Si el bit 0 de STATUS se encuentra en 0, se salta la linea inmediata inferior, si esta en 1, se ejecuta la linea inmediata inferior
Acarreo1:    
	incf    0x21,F  ;Como si hubo acarreo, entonces, incremento en 1 la parte 2 de A y el resultado lo guardo en 0x21
	//Sumando las partes 2 de A y B
NoAcarreo1:  
	bcf	STATUS,0    ;Limpio o pongo en 0 el bit o bandera de acarreo del registro status
	movf    0x25,W  ;Muevo el contenido de la parte 2 de B (en la 0x25) a W
	addwf	0x21,W	    ;Sumo la parte 2 de A (en W) con la parte 2 de B (en 0x21), el resultado se guarda en W
	movwf	0x29	    ;Guardo el resultado (en W) en la localidad 0x29 (parte 2 del resultado)
	btfsc	STATUS,0    ;Verifico si hubo acarreo entre las partes 2 de A y B
Acarreo2:
	incf	0x22,F	    ;Si hubo acarreo, incremento en 1 la parte 3 de A
	//Sumando las partes 3 de B y A
NoAcarreo2:
	bcf	STATUS,0    ;Limpio el bit de acarreo
	movf	0x26,W	    ;Muevo el contenido de la parte 3 de B (en la 0x26) a W
	addwf	0x22,W	    ;Sumo la parte 3 de B (en W) con la parte 3 de A (en la 0x22), el resultado se guarda en W
	movwf	0x2a	    ;Guardo el resultado (en W) en 0x2a (Parte 3 del resultado)
	btfsc	STATUS,0    ;Verifico si hubo acarreo entre las partes 3 de A y B
Acarreo3:
	incf	0x23,F	    ;Si hubo acarreo, incremento en 1 la parte 4 de A
NoAcarreo3:
	bcf	STATUS,0    ;Limpio el bit de acarreo
	movf	0x27,W	    ;Muevo el contenido de la parte 4 de B (en la 0x27) a W
	addwf	0x23,W	    ;Sumo la parte 4 de B (en W) con la parte 4 de A (en la 0x23), el resultado se guarda en W
	movwf	0x2b	    ;Guardo el resultado (en W) en 0x2b (Parte 4 del resultado)
	btfsc	STATUS,0    ;Verifico si hubo acarreo entre las partes 4 de A y B
Acarreo4:
	incf	0x2c,F	    ;Incremento directamente el resultado parte 5
NoAcarreo4:	
	bcf	STATUS,0    ;Limpio bit de acarreo
	nop
	END
	
