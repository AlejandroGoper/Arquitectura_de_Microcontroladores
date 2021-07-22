; PIC16F628 Configuration Bit Settings

; Assembly source line config statements

#include "p16f628.inc"

; CONFIG
; __config 0xFF6A
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF

    org	0x00
    goto inicio
    org	0x05
   
inicio	bsf STATUS,5
    clrf    TRISB
    bsf	TRISA,4
    movlw   0x38
    movwf   OPTION_REG
    bcf	STATUS,5
reinicio    clrf    TMR0
continua    movf    TMR0,0
    call    tabla
    movwf   PORTB
    btfss   TMR0,5  ;cuando sea 16 reinicio
    goto continua
    goto reinicio
tabla	addwf	PCL,1
    retlw   0x00    ;cero
    retlw   0x01    ;uno
    retlw   0x02    ;dos
    retlw   0x04    ;tres
    retlw   0x08    ;cuatro
    retlw   0x10    ;cinco
    retlw   0x20    ;seis
    retlw   0x40    ;siete
    retlw   0x80    ;ocho
    retlw   0x80    ; aqui se empieza a regresar
    retlw   0x40
    retlw   0x20
    retlw   0x10
    retlw   0x08
    retlw   0x04
    retlw   0x02
    retlw   0x01
    retlw   0x00
end