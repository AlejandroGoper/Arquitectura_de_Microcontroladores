#include "p16f628.inc"

; CONFIG
; __config 0x3F79
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF
 
    org	0x00
    goto inicio
    org	0x05
inicio
    bsf STATUS,RP0  ;BANCO 1
    bsf	TRISA,4	; boton
    bcf	TRISB,2	;RB2 salida
    ; Activar  transmision.-
    bsf     TXSTA,TXEN      ; Habilita transmision
    bcf TXSTA,TX9 ; 8 bit transmission
    bcf TXSTA,SYNC ; asynchronous mode
    movlw   0x19            ; Configura velocidad a 9600 baudios con cristal de 4 Mhz
    movwf   SPBRG
    bcf     STATUS,RP0      ; Banco 0
    ;bsf RCSTA,CREN ; enable continuous receive mode
    ;bcf RCSTA,RX9 ; 8 bit reception
    ;bsf     RCSTA,SPEN      ; Habilitacion puerto serie

bucle
    btfss   PORTA,4
    goto prende
    goto apaga
prende
    movlw   d'1'
    movwf   TXREG
    goto    bucle
apaga
    movlw   d'0'
    movwf   TXREG
    goto bucle
    end
    