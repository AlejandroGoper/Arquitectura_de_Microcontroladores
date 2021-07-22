#include "p16f628.inc"

; CONFIG
; __config 0x3F79
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF
 
    org	0x00
    goto inicio
    org	0x05
   
inicio 
    clrf    CCP1CON
    CLRF    TMR2
    movlw   d'249'
    movwf   PR2
    movlw   0x9F
    movwf   CCPR1L
    clrf    INTCON
    bsf	STATUS,RP0
    bcf	TRISB,3 
    clrf    PIE1
    bcf	STATUS,RP0
    clrf    PIR1
    movlw   0x9C
    movwf   CCP1CON
    bsf	T2CON,TMR2ON
bucle
    btfss   PIR1,TMR2IF
    goto bucle
    bcf	PIR1,TMR2IF
    end