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
  Este prgrama enciende y apaga un led cada 1 segundo
  Para ello usamos una subrutina para generar un retardo de 1 segundo
  Teniendo en cuenta que la instrucción decfsz tarda 1us y la de goto 2us
  
  */
  
  
// Definición de etiquetas para los contadores de la subrutina de retardo  
C1  EQU	0x20
C2  EQU	0x21
C3  EQU	0x22
  
psect	absdata,abs,ovrld
	org	0x00
	goto	main
	org	0x05
psect	code
main:
    // Configuración
    clrf    PORTB	;Ponemos a 0 todos los bits del puerto B
    bsf	    STATUS,5	; Cambiamos al banco 1
    bcf	    STATUS,6	
    clrf    TRISB	; Ponemos todos los pines del puerto B como salidas
    bcf	    STATUS,5	; Regresamos al banco 0
    // Programa
loop: 
    movlw   1		; Muevo 1 a W
    xorwf   PORTB,F	; Al hacer xorwf si PORTB tiene 0, el resultado sera 1, si PORTB tiene 1 el resultado será 0 y el resultado lo dejo en PORTB
    call    retardo_1seg    ; Llamos la subrutina de retardo

    goto    loop
    
// Subrutina de retardo 1s
retardo_1seg:
    nop
    nop
    nop
    nop
    movlw   4	  ; Iteraciones para el ciclo 3	(1us)
    movwf   C3	  ; Guardamos en el contador (1us)
ciclo_3:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    movlw   248	  ; Iteraciones para el ciclo 2 (1us)
    movwf   C2	  ; Guardamos en el contador	(1us)
ciclo_2:
    nop
    nop
    nop
    movlw   250	  ; Iteraciones para el ciclo 1 (1us)
    movwf   C1    ; Guardamos en el contador	(1us)
ciclo_1:    
    nop		    ; Nada  (1us)
    decfsz  C1,F    ; Decrementamos en 1 y guardamos en C1 (1us si no es cero) (2 us si es cero)
    goto    ciclo_1 ; repetimos (2us)
    nop		    ; Nada (1us)
    decfsz  C2,F    ; Decrementamos en 1 y guardamos en C2 (1us si no es cero) (2 us si es cero)
    goto    ciclo_2 ; repetimos (2us)
    nop		    ; Nada (1us)
    decfsz  C3,F    ; Decrementamos en 1 y guardamos en C3 (1us si no es cero) (2 us si es cero)
    goto    ciclo_3 ; repetimos (2us)
    return
    
    end