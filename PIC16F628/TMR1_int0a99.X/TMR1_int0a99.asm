#include "p16f628.inc"

; CONFIG
; __config 0x3F79
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF

contador_1  equ	0x20
contador_2  equ	0x21
contador_3  equ	0x22
contador    equ	0x25
numero	equ 0x28
statusCOPY  equ 0x35
wCOPY	equ 0x36

    org	0x00
    goto inicio
    org	0x04
    movwf   wCOPY				; Guardar el estado actual del registro W
    movf    STATUS,W			; Mover el el registro STATUS a W
    movwf   statusCOPY			; Guardar el estado actual del registro STATUS
    goto interrupcion
    
inicio
    bsf STATUS,RP0
    clrf    TRISB
    bsf	TRISA,4	; boton interrupcion
    bcf	TRISA,1 ; led de interrupcion
    bcf TRISA,7	;pantalla decenas
    bcf TRISA,0	;pantalla unidades
    bsf INTCON,PEIE ;	Habilitamos interrupciones perifericas
    bsf   PIE1,TMR1IE	; Habilitamos las interrupciones del TMR1
    bcf	STATUS,RP0
    movlw   b'00110001' ; cuenta instrucciones TMR1 de 8 en 8
    movwf   T1CON
    BSF     INTCON, PEIE  ; Habilitamos interrupción por periféricos
    BSF     INTCON,GIE    ; HABILITAMOS TODAS LAS INTERRUPCIONES
    clrf    0x30
    movlw   b'00011110'
    movwf   TMR1H
    movlw   b'11100000'
    movwf   TMR1L
    clrf numero
    bcf	TRISA,1	;Apago LED interrupcion
    ;bcf	INTCON,6    ; limpio bandera
    bsf	T1CON,TMR1ON		; Activar el Timer 1
    bcf PIR1,TMR1IF ;limpio bandera
    
reinicio2   
    btfss   TRISA,4
    call led    
    btfsc   PIR1,TMR1IF ; checo si ya paso medio segundo
    call configura  
    bcf	PORTA,7 ; apagar decenas
    bsf	PORTA,0	; prender unidades
    movf    numero,0  ; muevo numero a W
    call tabla	; 
    movwf   PORTB   ; mando numero de unidades a la pantalla
    movlw   d'1'
    call retardo_x1ms	; espero un ms
    bcf	PORTA,0 ; apagar unidades
    clrf    PORTB   ; limpio PUERTOB
    btfss   numero,3  ; verifico si el contador de unidades llego a 8
    goto    sigue   ; 
    btfss   numero,1  ;verifico si el contador de unidades llego a 2
    goto    sigue
    clrf    numero    ; limpio TMR0 porque llego a 10
    incf    0x30,1  ;incremento decenas en 1
    btfss   0x30,3  ; verifico si las decenas llegaron a 8
    goto    sigue
    btfss   0x30,1  ; verifico si las decenas llegaron a 2
    goto    sigue
    clrf    0x30
    clrf    numero
    goto    reinicio2	; reiniciar todo cuando las decenas lleguen a 10

interrupcion
    BCF   PIR1,TMR1IF     ; BORRO LA BANDERA DE INTERRUPCIÓNPOR TMR1
    movlw   b'00011110'
    movwf   TMR1H
    movlw   b'11100000'
    movwf   TMR1L
    movf    statusCOPY,w		; Recuperar la copia del registro STATUS
    movwf	STATUS				; Restaurar el estado anterior a la interrupción del registro STATUS
    swapf   wCOPY,f
    swapf   wCOPY,w			; Restaurar el estado anterior a la interrupción del registro W
    btfsc   0x29,1  ;me fijo si ya llego a 2
    incf    numero
    btfsc   0x29,1
    clrf    0x29
    btfss   0x29,1
    incf    0x29
    
    retfie
    
led
    movlw   0x02    ;
    xorwf   PORTA,1
    return
   
configura
    ;bcf	INTCON,6    ;limpio bandera
    BCF   PIR1,TMR1IF     ; BORRO LA BANDERA DE INTERRUPCIÓNPOR TMR1
    return
    
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
