; PIC16F628A Configuration Bit Settings

; Assembly source line config statements

#include <xc.inc>

; CONFIG
  CONFIG  FOSC = INTOSCIO       ; Oscillator Selection bits (INTOSC oscillator: I/O function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled)
  CONFIG  PWRTE = ON            ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  MCLRE = ON            ; RA5/MCLR/VPP Pin Function Select bit (RA5/MCLR/VPP pin function is MCLR)
  CONFIG  BOREN = ON            ; Brown-out Detect Enable bit (BOD enabled)
  CONFIG  LVP = OFF             ; Low-Voltage Programming Enable bit (RB4/PGM pin has digital I/O function, HV on MCLR must be used for programming)
  CONFIG  CPD = OFF             ; Data EE Memory Code Protection bit (Data memory code protection off)
  CONFIG  CP = OFF              ; Flash Program Memory Code Protection bit (Code protection off)
  
/*
  Este prgrama es para ejemplificar el direccionamiento indirecto
  Usamos la localidades FSR para guardar la dirección de memoria de destino de un dato
  y la INDF (0x00) para poner el dato allí y que inmediatamente se borre y se guarde en 
  la localidad que contiene la FSR
     
  Haremos uso de este hecho, para realizar un programa que guarde el número 10
  en 30 localidades consecutivas de memoria
  
  */
  
psect	absdata,abs,ovrld
	org	0x00
	goto	main
	org	0x05
psect	code
main:	
    // Ponemos la localidad inicial en el registro FSR
    movlw   0x20    
    movwf   FSR
loop:
    movlw   10	    ; Movemos un 10 a W
    movwf   INDF    ; Al momento de mover W a INDF (0x00) automáticamente se guardará en la localidad que contenga FSR y en 0x00 no queda nada
    incf    FSR,F   ; Incrementamos la localidad de FSR en 1, y el resultado lo dejo en FSR
    // Condicion de paro
    // Aqui especificamos la condición que sean 30 localidades de memoria
    bcf	    STATUS,2 ; Limpiamos la bandera (bit Z) de cero en el registro status
    movlw   0x3e    ; Si empezamos en la localidad 0x20 en hexadecimal, tras pasar 30 localidades de memoria, llegamos a la 0x3e
    xorwf   FSR,W   ; Comparamos si FSR es igual a W (0x3e), y el resultado se guarda en W, si si son iguales se levanta la bandera de 0 en status
		    ; El XORWF compara bit a bit ambos registros de memoria, si los bits son iguales el resultado es 0, si son diferentes es 1
		    ; cuando sea 0 completamente el resultado, habremos llegado al numero 0x3e
    btfss   STATUS,2	; Reviso si efectivamente la operación del XORWF dio cero (ya llegamos al numero deseado)
    goto    loop    ; Si aun no llega, nos regresamos al loop
    nop    ; Si ya llego, fin  