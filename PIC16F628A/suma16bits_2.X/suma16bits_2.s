#include <xc.inc>
/*
    Este programa realiza la suma de dos numeros de 16 bits.
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
	clrf	0x20
	clrf	0x21
	clrf	0x22
	clrf	0x23
	clrf	0x24
	clrf	0x25
	//Guardando las partes de los numeros de 16 bits
        movlw	10110010B   ;Muevo Parte baja del numero A de 16 bits a w
	movwf	0x20	    ;Lo guardo en la localidad 0x20
	movlw	00001100B   ;Muevo Parte alta del numero A de 16 bits a w
	movwf	0x21	    ;Lo guardo en la localidad 0x21
	movlw	00100001B   ;Muevo Parte baja del numero B de 16 bits a w
	movwf	0x22	    ;Lo guardo en la localidad 0x22
	movlw	00010011B   ;Muevo Parte alta del numero B de 16 bits a w
	movwf	0x23	    ;Lo guardo en la localidad 0x23
	bcf	STATUS,0    ;Limpio o pongo en 0 el bit o bandera de acarreo del registro status
	//Sumando las partes bajas de B y A
	movf	0x22,W	    ;Muevo el contenido de la localidad 0x22 (Parte baja de B) a W para hacer la suma
	addwf	0x20,W	    ;Sumo los contenidos de W con 0x20 y los dejo en W
	movwf	0x24	    ;Guardamos el resultado de la suma de las partes bajas de A y B en 0x24
	//Verificando si hubo acarreo entre las partes bajas (que la suma haya excedido los 8 bits)
	btfsc	STATUS,0    ;Si el bit 0 de STATUS se encuentra en 0, se salta la linea inmediata inferior, si esta en 1, se ejecuta la linea inmediata inferior
Acarreo:    
	incf    0x21,F  ;Como si hubo acarreo, entonces incremento en 1 la parte alta de A y el resultado lo guardo en 0x21
	//Sumando las partes altas de A y B
NoAcarreo:  movf    0x23,W  ;Muevo el contenido de la parte alta de A (en la 0x23) a W
	addwf	0x21,W	    ;Sumo la parte alta de A (en W) con la parte alta de B (en 0x21), el resultado se guarda en W
	movwf	0x25	    ;Guardo el resultado (en W) en la localidad 0x25 (parte alta del resultado)
	nop
	END
	
	