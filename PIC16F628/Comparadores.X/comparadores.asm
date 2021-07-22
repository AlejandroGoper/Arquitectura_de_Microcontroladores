#include "p16f628.inc"

; CONFIG
; __config 0x3F79
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF
 
    org	0x00
    goto inicio
    org	0x05
    
inicio
    movlw	b'00000101'	; Comparador C2 (RA2:RA1), el resto digitales
    movwf	CMCON
    bsf STATUS,RP0  ; banco 1
    movlw	b'00000110' ; Solo (RA2:RA1) análogos
    movwf	TRISA
    clrf	TRISB
    bcf STATUS,RP0  ; banco 0
    clrf	PORTB
main
    ; Pone a '0' ó '1' el RB0
    ; de acuerdo con el estado del bit
    ; de salida del comparador C2
    btfss   CMCON,C2OUT	
    bcf	    PORTB,0
    btfsc   CMCON,C2OUT
    bsf	    PORTB,0
    goto    main	
    end
    