; PIC16F628A Configuration Bit Settings

; Assembly source line config statements

#include <xc.inc>

; CONFIG
  CONFIG  FOSC = INTOSCIO       ; Oscillator Selection bits (INTOSC oscillator: I/O function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled)
  CONFIG  PWRTE = ON            ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  MCLRE = ON            ; RA5/MCLR/VPP Pin Function Select bit (RA5/MCLR/VPP pin function is MCLR)
  CONFIG  BOREN = ON            ; Brown-out Detect Enable bit (BOD enabled)
  CONFIG  LVP = OFF             ; Low-Voltage Programming Enable bit (RB4/PGM pin has digital I/O function, HV on MCLR must be used for programming)
  CONFIG  CPD = OFF             ; Data EE Memory Code Protection bit (Data memory code protection off)
  CONFIG  CP = OFF              ; Flash Program Memory Code Protection bit (Code protection off)
  
/*
  Examen Parcial 1:
  Por: Rocío Iraís Córdova Alfaro
     
  Instrucciones:
      Máquina de taladrado
    Se tiene que programar la secuencia de barrenado de una pieza realizada por un 
    taladro, esta secuencia se describe a continuación:
    Al accionar el pulsador "I" (RA0) el cabezal realiza un descenso rápido de aproximación, 
    activando el motor de bajada rápida "BR"(RB3). Al llegar al sensor "b" (RA2) se 
    desactiva la bajada rápida, se activa el relé "M" (RB1) que hace girar el motor 
    de la broca y se realiza un descenso lento para el taladrado de la pieza "BL" (RB4). 
    Cuando se activa el sensor "c" (RA3) se considera que la pieza está taladrada y se 
    desactiva el motor de bajada lenta. Se inicia una subida rápida del cabezal "SR" (RB0) 
    al tiempo que el relé "M" (RB1) de giro sigue activado. Cuando se alcanza el final de carrera 
    "a" (RA1), se detiene la subida rápida "SR"(RB0), el relé de giro "M" (RB1) y se activa una 
    señal acústica "A" (RB2) de aviso. El ciclo comienza con una nueva pulsación de "I" (RA0).
  
  */
  
psect	absdata,abs,ovrld
	org	0x00
	goto	main
	org	0x05
psect	code
main:	
    // Configuración
    bcf	    STATUS,6	;
    bsf	    STATUS,5	; Cambiamos al banco de memoria 1 para los configuradores de los puertos
   // Configurando entradas (1) y salidas (0)
    bsf	    TRISA,0	; RA0 es entrada 
    bsf	    TRISA,1	; RA1 es entrada
    bsf	    TRISA,2	; RA2 es entrada
    bsf	    TRISA,3	; RA3 es entrada
    
    bcf	    TRISB,0	; RB0 es salida
    bcf	    TRISB,1	; RB1 es salida
    bcf	    TRISB,2	; RB2 es salida
    bcf	    TRISB,3	; RB3 es salida 
    bcf	    TRISB,4	; RB4 es salida
    
    bcf	    STATUS,5	; Cambiamos al banco de memoria 0, para acceder y controlar los puerto
    
    // Programa principal
inicio:
    clrf    PORTB	; Al inciar apagamos todos los pines del puerto B (se inicia todo apagado)
    btfsc   PORTA,0	; Verificamos si se ha presionado el botón de inicio "I" en RA0
    goto    inicio	; sino se ha presionado (si RA0 tiene 1) no hay que hacer nada y regresamos a inicio
    goto    comienza_descenso_rapido	; si se presiono el botón (si RA0 tiene 0) comenzamos el proceso
comienza_descenso_rapido:
    // Debemos activar el descenso rápido "BR" -- RB3 mientras no se llegue al sensor "b" -- RA2
    // es decir, activamos RB3 mientras el sensor "b" (un pulsador en proteus)
    bsf	    PORTB,3	; Activamos el motor de descenso rápido en RB3 (led en PROTEUS)
    btfsc   PORTA,2	; Verificamos el sensor "b" en RA2
    goto    comienza_descenso_rapido	; Si esta apagado (si tiene 1) seguimos activando RB3
    goto    comienza_descenso_lento	; Si se activa (si tiene 0) comenzamos el proceso de descenso lento
comienza_descenso_lento:
    bcf	    PORTB,3	; Desactivo la bajada rápida
    bsf	    PORTB,1	; Se activa el relé "M" en (RB1) que hará girar el motor de la broca (LED en proteus)
    bsf	    PORTB,4	; Se activa el descenso lento "BL" en RB4 (para poder taladrar la pieza)
    // Se hará lo anterior mientras el sensor "c" en RA3 no se active 
    btfsc   PORTA,3	; Verifico el estado del sensor en RA3 (que también será un pulsador en proteus)
    goto    comienza_descenso_lento	; Si esta apagado (si tiene 1) seguimos taladrando (descenso lento)
    goto    pieza_taladrada	; Si esta activado (si tiene 0) la pieza esta taladrada por completo
pieza_taladrada:
    // Se debe realizar una subida rapida del cabezal mientras el sensor "a" en (RA1) que determina el final de la carrera este desactivado
subida_rapida:
    bcf	    PORTB,4	; Cuando la pieza esta taladrada se desactiiva el motor de bajada lenta "BL" en (RB4) (apagamos RB4)
    bsf	    PORTB,0	; Comienza una subida rapida del cabezal "SR" en (RB0) (activamos RB0)
    ; Esta instrucción de abajo no es necesaria pues RB1 no se desactiva, pero, solo por completitud del código...
    bsf	    PORTB,1	; Nos aseguramos que el relé M en (RB1) sigue activado (prendiendolo de nuevo)
    btfsc   PORTA,1	; Verificamos el estado del sensor "a" en (RA1)
    goto    subida_rapida   ; si esta apagado (si tiene 1) seguimos la subida rapida
    goto    aviso_final	    ; si esta encendido (si tiene 0)
aviso_final:
    bcf	    PORTB,0	;se detiene la subida rápida "SR" en (RB0) (apagamos RB0)
    bcf	    PORTB,1	; apagamos el relé de giro "M" en (RB1) (apagamos RB1)
    bsf	    PORTB,2	; Encendemos señal acustica "A" en (RB2) de aviso
    // La señal debe permanecer endedida hasta que demos clic en el botón de comenzar otra vez 
    btfsc   PORTA,0	; Verificamos el interruptor de inicio "I" en (RA0)
    goto    aviso_final	; si esta apagago (si tiene 1) seguimos dando el aviso final
    clrf    PORTB	; Apagamos todo y reiniciamos
    goto    comienza_descenso_rapido	; si esta encendido (si tiene 0) comenzamos de nuevo el ciclo desde el descenso rapido.
    nop
    end