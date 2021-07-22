#include "p16f628.inc"

; CONFIG
; __config 0x3F79
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF
 
    org	0x00
    goto inicio
    org	0x05
inicio
    bsf STATUS,RP0  ;BANCO 1
    movlw   0x02    ;
    movwf   TRISB   ;RB1 entrada  
    bcf	TRISB,0	;RB0 LED
    movlw   0x04    
    movwf   TXSTA   ; Configura modo asincrono, baud rate de alta velocidad
    movlw   0x19    ; Configura velocidad a 9600 baudios con cristal de 4 Mhz
    movwf   SPBRG
; Activar recepcion
    bcf     STATUS,RP0      ; Banco 0
    bsf     RCSTA,SPEN      ; Habilitacion puerto serie
    bsf     RCSTA,CREN      ; Habilita recepcion
bucle    
    btfss   PIR1,RCIF	;checo bandera
    bcf	PORTB,0
    goto bucle
    bsf	PORTB,0 ;prende led 
    bcf	PIR1,RCIF   ;limpio bandera
    goto buccle
    end