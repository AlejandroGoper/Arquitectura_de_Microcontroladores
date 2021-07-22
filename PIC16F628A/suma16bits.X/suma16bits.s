#include <xc.inc>
/*
Este programa utiliza los bits de confuguracion discutidos en la libreta
Además, de mostrar un ejemplo de suma de dos numeros de 8 bits que producen un
     numero de 16 bits (por lo tanto habrá acarreo) y además se produce un
     medio acarreo también (BIT DC en el STATUS)
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
    movlw   10111101B	;Movemos un 189d a W
    movwf   0x20	;Guardamos en la localidad 0x20 un 189d
    movlw   11010111B	;Movemos un 215d a W
    addwf   0x20,w	;Sumamos el contenido de 0x20 con W (189 + 215)
    nop
    END	 