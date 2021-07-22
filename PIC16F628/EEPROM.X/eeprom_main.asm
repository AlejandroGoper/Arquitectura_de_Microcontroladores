#include "p16f628.inc"

; CONFIG
; __config 0x3F79
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF
 
    org	0x00
    goto inicio
    org	0x05
    
    inicio
    bsf STATUS,RP0  ;banco 1
denuevo    movlw   0x08
    movwf   EEADR   ;apuntador a localidad deseada
    movlw   0x09
    movwf   EEDATA  ;guarda el dato que se quiere escribir en EEPROM
    bsf	EECON1,WREN ;habilita escritura
    movlw   0x55    ;prepara secuncia de seguridad
    movwf   EECON2  ;escribe primer dato de secuencia 
    movlw   0xAA    ;segundo dato
    movwf   EECON2  ; escribe segundo dato de secuencia
    bsf	EECON1,WR   ; iniciar ciclo de escritura
aunno    btfsc   EECON1,WR  ; escribir
    goto aunno	;si WR es 1 aun no termina
    btfsc   EECON1,WRERR    ; verifica si hay error
    goto denuevo    ;salta si no hay error
    bcf EECON1,WREN ;deshabilita escritura
    bcf STATUS,RP0  ; regresa banco 0
    goto listo
listo    
    end