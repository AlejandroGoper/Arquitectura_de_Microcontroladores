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
   
inicio    
    bsf STATUS,RP0
    clrf    TRISB
    bsf	TRISA,4	; boton TMR0 
    bcf TRISA,7	;pantalla decenas
    bcf TRISA,0	;pantalla unidades
    movlw   0x38
    movwf   OPTION_REG
    bcf	STATUS,RP0
    call readUNID   ;eeprom a W
    movwf   TMR0
    call readDEC    ;eeprom a w
    movwf   0x30
reinicio2   
    bcf	PORTA,7 ; apagar decenas
    bsf	PORTA,0	; prender unidades
    movf    TMR0,0  ;mueve TMR0 a W
    call tabla	; 
    movwf   PORTB   ; mando numero de unidades a la pantalla
    movlw   d'1'
    call retardo_x1ms	; espero un ms
    bcf	PORTA,0 ; apagar unidades
    CLRF    PORTB
    movf    TMR0,0  ; muevo TMR0 a W
    call    saveUNID	; guardo unidades a EEPROM
    btfss   TMR0,3  ; verifico si el contador de unidades llego a 8
    goto    sigue   ; 
    btfss   TMR0,1  ;verifico si el contador de unidades llego a 2
    goto    sigue
    clrf    TMR0    ; limpio TMR0 porque llego a 10
    incf    0x30,1  ;incremento decenas en 1
    movf    0x30,0  ;muevo lo de 0x30 a W
    call    saveDEC ;guardo decenas en EEPROM
    btfss   0x30,3  ; verifico si las decenas llegaron a 8
    goto    sigue
    btfss   0x30,1  ; verifico si las decenas llegaron a 2
    goto    sigue
    clrf    TMR0    ;aqui las decenas llegaron a 10
    movf    TMR0,0
    call saveUNID
    clrf    0x30
    movf    0x30,0
    call saveDEC
    goto reinicio2	; reiniciar todo cuando las decenas lleguen a 10
    
sigue	
    CLRF PORTB
    bcf	PORTA,0 ; unidades  apago
    bsf PORTA,7 ; prendo decenas
    movf   0x30,0    ;muevo lo de 0x30 a W
    call tabla
    movwf   PORTB   ; pongo numero en pantala
    movlw   d'1'
    call retardo_x1ms	; espero un ms
    bcf	PORTA,7	;decenas apago
    clrf    PORTB
    goto reinicio2
      
retardo_x1ms
    movwf	contador
    ciclo_1ms
    movlw	d'25' ; 250
    movwf	contador_1
    ciclo1_1ms
    nop
    decfsz  contador_1,1
    goto    ciclo1_1ms
    decfsz  contador,1
    goto    ciclo_1ms
    return
    
saveUNID
    bsf STATUS,RP0  ;banco 1
denuevoUNID
    movwf   EEDATA  ;guarda el dato que se quiere escribir en EEPROM
    movlw   0x08    ;
    movwf   EEADR   ;apuntador a localidad deseada
    bsf	EECON1,WREN ;habilita escritura
    movlw   0x55    ;prepara secuncia de seguridad
    movwf   EECON2  ;escribe primer dato de secuencia 
    movlw   0xAA    ;segundo dato
    movwf   EECON2  ; escribe segundo dato de secuencia
    bsf	EECON1,WR   ; iniciar ciclo de escritura
aunnoUNID    
    btfsc   EECON1,WR  ; escribir
    goto aunnoUNID	;si WR es 1 aun no termina
    btfsc   EECON1,WRERR    ; verifica si hay error
    goto denuevoUNID    ;salta si no hay error
    bcf EECON1,WREN ;deshabilita escritura
    bcf STATUS,RP0  ; regresa banco 0
    return
    
saveDEC
    bsf STATUS,RP0  ;banco 1
denuevoDEC
    movwf   EEDATA  ;guarda el dato que se quiere escribir en EEPROM
    movlw   0x09    ;
    movwf   EEADR   ;apuntador a localidad deseada
    bsf	EECON1,WREN ;habilita escritura
    movlw   0x55    ;prepara secuncia de seguridad
    movwf   EECON2  ;escribe primer dato de secuencia 
    movlw   0xAA    ;segundo dato
    movwf   EECON2  ; escribe segundo dato de secuencia
    bsf	EECON1,WR   ; iniciar ciclo de escritura
aunnoDEC    
    btfsc   EECON1,WR  ; escribir
    goto aunnoDEC	;si WR es 1 aun no termina
    btfsc   EECON1,WRERR    ; verifica si hay error
    goto denuevoDEC    ;salta si no hay error
    bcf EECON1,WREN ;deshabilita escritura
    bcf STATUS,RP0  ; regresa banco 0
    return
    
    
readUNID
    bsf	STATUS,RP0
    movlw   0x08    ;localidad de unidades
    movwf   EEADR   ;apuntador a esa localidad
    bsf	EECON1,RD   ;leer
    movf    EEDATA,W	;mueve el dato de EEPROM a W
    bcf	STATUS,RP0
    return
    
readDEC
    bsf	STATUS,RP0
    movlw   0x09    ;localidad de decenas
    movwf   EEADR   ;apuntador a esa localidad
    bsf	EECON1,RD   ;leer
    movf    EEDATA,W	;mueve el dato de EEPROM a W
    bcf	STATUS,RP0
    return
    
    
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
    
    end
