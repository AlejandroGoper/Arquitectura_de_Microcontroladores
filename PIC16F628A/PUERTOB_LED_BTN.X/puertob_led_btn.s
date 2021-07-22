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
  Este prgrama es para encender un LED conectado al puerto B en el pin RB0;
  
  Es para ejemplificar la configuración del puerto con TRISB como salida/entrada
  digital.
  
  Se pondrá un Botón en el pin RB7; cuando se activa, se prede el LED en RB0 
  cuando no se activa se apaga el LED
  
  */
  
psect	absdata,abs,ovrld
	org	0x00
	goto	main
	org	0x05
psect	code
main:	
    //Cambiamos banco de memoria al 1
    // Para ello necesitamos hacer que RP0 = 1 y RP1 = 0
    bsf	    STATUS,5	; Ponemos 1 en RP0 
    bcf	    STATUS,6	; Ponemos 0 en RP1
    
    //Configuramos todo el puerto B como salidas digitales, poniendo a 0 todo el TRISB
    clrf    TRISB
    bsf	    TRISB,7	; Pongo el RB7 como entrada digital 
    
    //Regresamos al banco 0 de memoria RAM debido a que allí se encuentran los puertos
    // Para ello, dado que ya tenemos que RP1=0, resta solo hacer RP0 = 0
    bcf	    STATUS,5	;
    
    // Código principal
    /*
	Para encender un LED conectado a una patita del Puerto B configurado como salida,
	basta con escribir un 1 en el bit correspondiente a la patita o pin del puerto B
	
	y necesitamos verificar el estado de la localidad PORTB en el bit 7 (RB7)
	dependiendo de este estado, el led, se apaga o se prende.
    */
bucle_principal:
    btfss   PORTB,7	; Verificamos si hay un 1 (si no se ha presionado el botón) en RB7
    goto    encender_led    ; Si no hay un 1, debemos encender el led
    goto    apagar_led    ; Si si hay 1, debemos apagar el led
encender_led:
    bsf	    PORTB,0	; Encendemos el LED en RB0 haciendo RB0=1 
    goto    bucle_principal
apagar_led:
    bcf	    PORTB,0	; Apagamos el LED en RB0 haciendo RB0=0
    goto    bucle_principal
    nop
    end