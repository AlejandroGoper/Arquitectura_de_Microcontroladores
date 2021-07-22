; PIC16F628 Configuration Bit Settings

; Assembly source line config statements

#include "p16f628.inc"

; CONFIG
; __config 0xFF6A
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF

contador_1  equ	0x20
contador_2  equ	0x21
contador_3  equ	0x22
contador    equ	0x25

    org	0x00
    goto inicio
    org	0x05
   
inicio
    bsf	STATUS,5 ;rp0
    bsf	TRISA,4	;boton
    movlw   0x38
    movwf   OPTION_REG
    bcf	TRISB,3	;led
    bcf	STATUS,5
    clrf    TMR0
checa
    movlw   d'23'
    clrf    STATUS
    subwf   TMR0,0
    btfss   STATUS,Z
    goto checa
    
enciende
    bsf	PORTB,3
    movlw	d'2'
    call	retardo_x1s
    bcf	PORTB,3
    goto final
    
retardo_x1s
	movwf	contador
ciclo_1s
	movlw   d'10'	;10
        movwf   contador_1
ciclo1_1s
	movlw	d'100'	;100
	movwf	contador_2		
ciclo2_1s
        movlw	d'250'	;250
        movwf	contador_3
ciclo3_1s
	nop
	decfsz	contador_3,1
	goto    ciclo3_1s
	decfsz  contador_2,1
	goto	ciclo2_1s
	decfsz	contador_1,1
	goto    ciclo1_1s
	decfsz	contador,1
	goto	ciclo_1s
	return
	
final
	nop
	end	


