
; PIC16F628 Configuration Bit Settings

; Assembly source line config statements

#include "p16f628.inc"

; CONFIG
; __config 0x3F79
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF


    org	0x00
    goto inicio
    org	0x04
    goto interrupcion
inicio 
    bsf STATUS,RP0
    bsf	TRISB,0
    bcf	TRISB,1
    movlw   0x90
    movwf   INTCON
    bcf	OPTION_REG,6	;boton falling
    bcf	STATUS,RP0
    bcf	PORTB,1 ; apago boton
nada
    nop
    nop
    goto nada
    
interrupcion
    btfss   INTCON,1	;INTF
    nop
    bcf	INTCON,1
    movlw   0x02
    xorwf   PORTB,1
    retfie
end