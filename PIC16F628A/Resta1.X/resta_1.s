#include <xc.inc>

/*
    Este programa realiza la resta de dos numeros de 8 bits.
    Se introducen nuevas instrucciones SUBLW, SUBWF y COMP
    El programa decide si la resta fue un numero negativo o no y lo guarda
    en determinada localidad de memoria
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
	//Limpio variables a utilizar
	clrf	0x22	;Resultado
	//Algoritmo que resta 100 - 50
	movlw	50	;Muevo 50 a W
	sublw	100	;Resto 100 - W, es decir, 100-50 y el resultado se queda en W
	movwf	0x22	;Guardo el resultado en la localidad 0x22
	nop
	END
	