#include <xc.inc>

/*
    Este programa realiza la resta de dos numeros de 16 bits.
    19727 - 17766 = 1961
    El programa guarda el numero en dos localidades de memoria.
     
    Para mejorara la visualización se utilizan etiquetas a las localidades de 
    memoria definidas por el comando EQU
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

; Defino mis variables (etiquetas de localidades de memoria)
A1	EQU	0x21	;Parte 1 del numero A = 19727
A2	EQU	0x22	;Parte 2 del numero A
B1	EQU	0x23	;Parte 1 del numero B = 17766
B2	EQU	0x24	;Parte 2 del numero B
R1	EQU	0x25	;Parte 1 del resultado = 1961
R2	EQU	0x26	;Parte 2 del resultado
  
psect	absdata,abs,ovrld
	org	0x00
	goto	main
	org	0x05
psect	code
main:
	//Limpio las variables a utilizar
	clrf	A1
	clrf	A2
	clrf	B1
	clrf	B2
	clrf	R1
	clrf	R2
	bcf	STATUS,0
	//Asigno los valores respectivos a cada variable
	movlw	00000000B   ; Muevo parte 1 de A a W
	movwf	A1	    ; Muevo parte 1 de A a A1
	movlw	11000000B   ; Muevo parte 2 de A a W
	movwf	A2	    ; Muevo parte 2 de A a A2
	movlw	01100110B   ; Muevo parte 1 de B a W
	movwf	B1	    ; Muevo parte 1 de B a B1
	movlw	01000101B   ; Muevo parte 2 de B a W
	movwf	B2	    ; Muevo parte 2 de B a B2
	//Comienzo el algoritmo	
resta_parte_1:
	movf	B1,W	    ; Muevo B1 a W
	subwf	A1,W	    ; Resto A1-B1 y el resultado lo dejo en W
	movwf	R1	    ; Guardo el resultado de la operacion en R1
	;Reviso ahora si el resultado fue positivo o negativo, en el bit 0 (acarreoo) del registro STATUS
	btfsc	STATUS,0    ; Si el bit 0 de STATUS es 0 (negativo), entonces se salta la linea de abajo
	goto	resta_parte_2
numero_negativo_1:
	//Si llegamos hasta aqui, el resultado de la operacion fue un numero negativo y debemos restarle 1 a la parte 2 del numero A
	// que es lo mismo que "pedirle prestado"
	movlw	1	    ;movemos 1 a W
	subwf	A2,F	    ; Resto A2-W y lo dejo en F
	//Si al restarle uno a la parte 2 de A nos da un numero negativo, quiere decir que la parte 2 de A es 0
	// Y solo debemos sacar el complemento a 1 de la parte 2 de B
	btfsc	STATUS,0    ; Si el bit 0 de STATUS es 0 (negativo), entonces se salta la linea de abajo
	goto	resta_parte_2
	goto	parte_A2_nula
parte_A2_nula:
	//Dado que ya identificamos que no hay parte 2, es decir, es 0
	// Y como la parte A2 es nula, tendremos en esta localidad guardado el complemento a 2 de 1 que corresponde al numero negativo -1
	// 1111 1111 a este numero me refiero
	movf	B2,W	    ; Muevo B2 a W
	subwf	A2,W	    ; Resto A2 - W y el resultao lo dejo en W
	movwf	R2	    ; Guardo el resultado en R2
	//Este resultado de esta operacion siempre positivo y ademas me regresa el complemento a 1 de la parte B2
	//Pero el numero el resultado en sí mismo, es negativo porque la parte A2 es 0
	goto	numero_negativo_absoluto 
resta_parte_2:
	movf	B2,W	    ; Muevo B2 a W
	subwf	A2,W	    ; Resto A2 - B2 y el resultao lo dejo en W
	movwf	R2	    ; Guardo el resultado de la operacion en R2
	;Revisamos si el resultado fue positivo o negativo, de nuevo:
	btfsc	STATUS,0    ;
	goto	numero_positivo_absoluto
numero_negativo_absoluto:
	//Si llegamos hasta aquí, el resultado fue un número negativo y debemos sacar el complemento a 2 a todo el numero, dado que 
	// toda la resta fue un numero negativo
	//pero ya no decrementamos en ninguna localidad de memoria, como se hizo en la parte 1
	// Primero saco el complemento a 1 de todo el numero
	comf	R2,F	    ; Saco complemento a 1 de R2 y lo guardo en R2
	comf	R1,F	    ; Saco complemento a 1 de R1 y lo guardo en R1
	// Unicamente incremento la parte 1 del resultado para sacar el complemento a 2 de todo el numero
	incf	R1	    ; Incremento en 1 R1 para sacar el complemento a 2
numero_positivo_absoluto:
	nop
	END