; PIC16F628 Configuration Bit Settings

; Assembly source line config statements

#include "p16f628.inc"

; CONFIG
; __config 0x3F79
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF

    org	0x00
    goto inicio
    org	0x05
inicio bsf STATUS,5
    clrf    TRISB
    bsf	TRISA,4
    bsf TRISA,3	;boton falso
    movlw   0x38
    movwf   OPTION_REG
    bcf	STATUS,5
reinicio    clrf    TMR0
continua    movf    TMR0,0
    call    tabla
    movwf   PORTB
    btfss   TMR0,7  ;cuando sea 8
    goto continua
    movlw  b'01100111'	    ;nueve
    movwf   PORTB
    goto reinicio
tabla	addwf	PCL,1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    retlw   b'00111111'    ;cero
        nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    retlw   b'00110000'    ;uno
        nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    retlw   b'01011011'    ;dos
        nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    retlw   b'01001111'    ;tres
        nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    retlw   b'01100110'    ;cuatro
        nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    retlw   b'01101101'    ;cinco
        nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    retlw   b'01111101'    ;seis
        nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    retlw   b'00000111'    ;siete
        nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    retlw   b'01111111'    ;ocho
        nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    retlw   b'01100111'	    ;nueve
end