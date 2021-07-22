#include "p16f628.inc"

; CONFIG
; __config 0x3F79
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF

contador_1  equ	0x20
contador_2  equ	0x21
contador_3  equ	0x22
contador    equ	0x25

    org	0x00
    goto inicio
    org	0x05
inicio bsf STATUS,RP0
    clrf    TRISB
    clrf    TRISA
    bsf	TRISA,4	; boton TMR0 
    bcf TRISA,7	;pantalla decenas
    bcf TRISA,0	;pantalla unidades
    movlw   0x38
    movwf   OPTION_REG
    bcf	STATUS,RP0
    clrf    TMR0
    clrf    0x30
    CLRF PORTB
;reinicio    clrf 0x30	;limpiar contador decenas
 ;   clrf    TMR0
reinicio2   
    bcf	PORTA,7 ; apagar decenas
    bsf	PORTA,0	; prender unidades
    movf    TMR0,0  ; muevo TMR0 a W
    call tabla	; 
    movwf   PORTB   ; mando numero de unidades a la pantalla
    movlw   d'1'
    call retardo_x1ms	; espero un ms
    bcf	PORTA,0 ; apagar unidades
    clrf    PORTB   ; limpio PUERTOB
    ;movlw   d'1'
    ;call retardo_x1ms	; espero un ms
    btfss   TMR0,3  ; verifico si el contador de unidades llego a 8
    goto    sigue   ; 
    btfss   TMR0,1  ;verifico si el contador de unidades llego a 2
    goto    sigue
    clrf    TMR0    ; limpio TMR0 porque llego a 10
    incf    0x30,1  ;incremento decenas en 1
    btfss   0x30,3  ; verifico si las decenas llegaron a 8
    goto    sigue
    btfss   0x30,1  ; verifico si las decenas llegaron a 2
    goto    sigue
    clrf    0x30
    clrf    TMR0
    goto    reinicio2	; reiniciar todo cuando las decenas lleguen a 10
    
sigue
    CLRF PORTB
    bcf	PORTA,0 ; unidades  apago
    bsf PORTA,7 ; prendo decenas
    movf    0x30,0  ;muevo lo que tienen las decenas a W
    call tabla
    movwf   PORTB   ; pongo numero en pantala
    movlw   d'1'
    call retardo_x1ms	; espero un ms
    bcf	PORTA,7	;decenas apago
    clrf    PORTB
    ;movlw   d'1'
    ;call retardo_x1ms
    ;bsf	PORTA,0 ; prender unidades
    goto reinicio2
      

tabla	addwf	PCL,1
    retlw   b'00111111'    ;cero
    retlw   b'00000110'    ;uno
    retlw   b'01011011'    ;dos
    retlw   b'01001111'    ;tres
    retlw   b'01100110'    ;cuatro
    retlw   b'01101101'    ;cinco
    retlw   b'01111101'    ;seis
    retlw   b'00000111'    ;siete
    retlw   b'01111111'    ;ocho
    retlw   b'01100111'	    ;nueve
        
    
retardo_x1ms
    movwf	contador
    ciclo_1ms
    movlw	d'25' ; 
    movwf	contador_1
    ciclo1_1ms
    nop
    decfsz  contador_1,1
    goto    ciclo1_1ms
    decfsz  contador,1
    goto    ciclo_1ms
    return
    
    
    end