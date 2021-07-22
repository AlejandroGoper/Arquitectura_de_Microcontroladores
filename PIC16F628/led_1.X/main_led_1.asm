    ; PIC16F628 Configuration Bit Settings

; Assembly source line config statements

#include "p16f628.inc"

; CONFIG
; __config 0xFF6A
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF
 
    org	0x00
    goto    inicio
    org	0x05
inicio
    bsf	STATUS,5    ;RB0
    clrf TRISB
    bcf	STATUS,5
    movlw   d'1'
    movwf   PORTB
    end