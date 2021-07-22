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
                