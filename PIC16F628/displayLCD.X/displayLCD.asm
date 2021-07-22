#include "p16f628.inc"
; CONFIG
; __config 0x3F79
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF

list p=16f628      ;Procesador PIC16c84  
list c=132        ;Listado a 132 caracteres

 
TIMER0     equ 01            ;Registro del TIMER0
OPCION     equ 0x1           ;Registro de opciones,p gina 1
RA         equ 05            ;Puerta A
RB         equ 06            ;Puerta B
DATO_A     equ 0xc           ;Registro del dato A
DATO_B     equ 0xd           ;Registro del dato B
RESUL      equ 0xe           ;Registro de resultados
TEMPO1     equ 0xf           ;Registro temporal 1
TEMPO2     equ 0x10          ;Registro temporal 2
OFFSET     equ 0x11          ;Variable de desplazamientos de mensajes
RP0     EQU     05h          ;Bit 5 registro STATUS
Digito	equ 0x30
	
    org	0x00
    goto inicio
    org	0x05
    
inicio 
    CLRF    Digito             ;Pone a 0 la variable digito 
    CALL    LCD_PORT    ;Puertos en modo LCD 
    BCF     RA,0              ;Desactiva RS del modulo LCD
    BCF     RA,2              ;Desactiva E del modulo LCD 
START    
    CALL    LCD_INI          ;Inicia LCD (CFG puertos...) 
    MOVLW   b'00000001'   ;Borrar LCD y Home 
    CALL    LCD_REG 
    MOVLW   b'00000110'  
    CALL    LCD_REG 
    MOVLW   b'00001100'   ;LCD On, cursor Off,Parpadeo Off 
    CALL    LCD_REG 
    MOVLW   0x80               ;Direccion caracter
    CALL    LCD_REG 

REPETIR  MOVF	Digito,w          ;W=Digito
    CALL    DATO_1          ;Coge el caracter 
    IORLW   0                      ;Compara 
    BTFSC   STATUS,2       ;Es el ultimo? 
    GOTO    acabar            ;Si 
    CALL    LCD_DATOS   ;Visualiza caracter 
    INCF    Digito,f             ;Incrementa numero de Digito
    GOTO    REPETIR           ;Vuelve a escribir
acabar   
    nop
    goto  acabar              ;Buclee infinito

LCD_E          BSF     RA,2            ;Activa señal E
                NOP                     ;Espera 1uS
                BCF     RA,2            ;Desactiva señal E
                RETURN        
                              
 LCD_BUSY       BSF     RA,1            ;Pone el LCD en modo lectura
                BSF     STATUS,5        ;Selecciona el Banco 1
                MOVLW   0xFF  
                MOVWF   TRISB           ;Puerta B act£a de entrada
                BCF     STATUS,5        ;Selecciona el Banco 0
                BSF     RA,2            ;Activa el LCD (Señal E)
                NOP           
 L_BUSY         BTFSC   RB,7            ;Chequea el bit BUSY
                GOTO    L_BUSY          ;Est  a "1" (Ocupado)
                BCF     RA,2            ;Desactiva el LCD (Se¤al E)
                BSF     STATUS,5        ;Selecciona el Banco 1
                CLRF    TRISB           ;Puerta B actua como salida
                BCF     STATUS,5        ;Selecciona el Banco 0
                BCF     RA,1            ;Pone el LCD en modo escritura
                RETURN        
                              
 LCD_REG        BCF     RA,0            ;Desactiva RS (Modo instruccion)
                MOVWF   RB              ;Saca el codigo de instruccion
                CALL    LCD_BUSY        ;Espera a que se libere el LCD
                GOTO    LCD_E           ;Genera pulso en señal E
                              
 LCD_DATOS      BCF     RA,0            ;Desactiva RS (Modo instrucci¢n)
                MOVWF   RB              ;Valor ASCII a sacar por RB
                CALL    LCD_BUSY        ;Espera a que se libere el LCD
                BSF     RA,0            ;Activa RS (Modo dato)  
                GOTO    LCD_E           ;Genera pulso en señal E
                              
 LCD_INI        MOVLW   b'00111000'
                CALL    LCD_REG         ;Codigo de instruccion
                CALL    DELAY_5MS       ;Temporiza 5 mS.
                MOVLW   b'00111000'
                CALL    LCD_REG         ;Codigo de instruccion
                CALL    DELAY_5MS       ;Temporiza 5 mS.
                MOVLW   b'00111000'
                CALL    LCD_REG         ;Codigo de instruccion
                CALL    DELAY_5MS       ;Temporiza 5 mS.
                RETURN            
                              
 LCD_PORT       BSF     STATUS,5        ;Selecciona el banco 1 de datos
                CLRF    TRISB           ;RB se programa como salida
                MOVLW   b'00011000'     ;RA<4:3> se programan como entradas
                MOVWF   TRISA           ;RA<2:0> se programan como salidas
                BCF     STATUS,5        ;Selecciona el banco 0 de datos
                                        
               ;MOVLW   b'00000000'      
               ;MOVWF   INTCON          ;Desactiva interrupciones
                BCF     RA,0            ;Desactiva RS del modulo LCD
                BCF     RA,2            ;Desactiva E del modulo LCD
         
;****************************************************************************                                                               
;DELAY_5MS genera una temporizacion de 5mS necesario para la secuencia de
;inicio del LCD                         
                                        
DELAY_5MS  	movlw 	0x1a                   
    movwf 	DATO_B                 
    clrf 	DATO_A                  
DELAY_1	decfsz 	DATO_A,1              
    goto 	DELAY_1                 
    decfsz 	DATO_B,1              
    goto 	DELAY_1                 
    return
     
    
    
;<<<<<<---------------------- TABLA DE DATOS ------------------------->>>>>>> 

DATO_1 ADDWF  PCL,1 
    RETLW  'H' 
    RETLW  'O'
    RETLW  'L' 
    RETLW  'A' 
    RETLW  ' ' 
    RETLW  'M' 
    RETLW  'U' 
    RETLW  'N' 
    RETLW  'D' 
    RETLW  'O' 
    RETLW 0x00 
    
    
    end