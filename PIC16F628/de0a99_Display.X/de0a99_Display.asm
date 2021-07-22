; PIC16F628 Configuration Bit Settings

; Assembly source line config statements

#include "p16f628.inc"
contador_1  equ	0x20
contador_2  equ	0x21
contador_3  equ	0x22
contador    equ	0x25

; CONFIG
; __config 0xFF6A
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF

    org	0x00
    goto inicio
    org	0x05
inicio bsf STATUS,5
    clrf    TRISB
    bsf	TRISA,4
    movlw   0x38
    movwf   OPTION_REG
    bcf	STATUS,5
reinicio    clrf    TMR0
continua    movf    TMR0,0
    call    tabla
    movwf   PORTB
    btfss   TMR0,5  ;cuando sea 8
    goto continua
    goto reinicio
tabla	addwf	PCL,1
    retlw   b'00111111'    ;cero
    retlw   b'00110000'    ;uno
    retlw   b'01011011'    ;dos
    retlw   b'01001111'    ;tres
    retlw   b'01100110'    ;cuatro
    retlw   b'01101101'    ;cinco
    retlw   b'01111101'    ;seis
    retlw   b'00000111'    ;siete
    retlw   b'01111111'    ;ocho
    retlw   b'01100111'	    ;nueve
end