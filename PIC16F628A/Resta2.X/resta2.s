#include <xc.inc>

/*
    Este programa realiza la resta de dos numeros de 8 bits.
    Se introducen nuevas instrucciones SUBLW, SUBWF y COMF
    El programa decide si la resta fue un numero negativo y lo guarda
    en determinada localidad de memoria, luego saca el complemento a 2 para
    determinar el valor absoluto del numero negativo resultado de la resta.
     
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
NumeroA	    EQU	    0x21
Resultado   EQU	    0x22
  
psect	absdata,abs,ovrld
	org	0x00
	goto	main
	org	0x05
psect	code
main:	
	//Limpio variables a utilizar
	clrf	NumeroA
	clrf	Resultado
	//Algoritmo que resta 50 - 100
	movlw	0	;Muevo 50 a W
	movwf	NumeroA	;Guardo 50 en la variable NumeroA
	movlw	1	;Muevo 100 a W
	subwf	NumeroA,W	;Resto NumeroA - W, es decir, 50-100 y el resultado se queda en W
	movwf	Resultado	;Guardo el resultado en la variable Resultado
	//Al realizar esta resta, el resultado que se queda en W y en Resultado es el complemento a 2 del resultado correcto.
	//Revisar que la bandera de acarreo en el registro status se encuentre en 0 y realizar el complemento a 2 para ver el numero correcto
	btfsc	STATUS,0    ;Reviso la bandera de acarreo, 0 - numero negativo, 1 - numero positivo, si si es 0 se salta la linea inmediata inferior   
	goto positivo
negativo:
	comf	Resultado,F	;Saco el complemento a 1 del numero almacenado en 0x22 y lo guardo en Resultado (bandera F)
	incf	Resultado	;Incremento el valor del complemento a 1 de Resultado, para obtener el complemento a 2 y así saber el número.
positivo:
	nop
	END