
	org 0x00
	goto inicio
	org 0x05
inicio
    MOVLW d'13'
    MOVWF 0x22
    MOVLW d'52'
    MOVWF 0x20
    MOVLW d'165'
    MOVWF 0x21
    BCF   0x03,0
    ADDWF 0x20,0
    MOVWF 0x28
    BTFSC 0x03,0
    INCF  0x22,1
    BCF   0x03,0
    MOVLW d'117'
    MOVWF 0x24
    MOVLW d'109'
    MOVWF 0x23
    ADDWF 0x22,0
    MOVWF 0x29
    BTFSC 0x03,0
    INCF  0x24,1
    BCF   0x03,0
    MOVLW d'81'
    MOVWF 0x26
    MOVLW d'113'
    MOVWF 0x25
    ADDWF 0x24,0
    MOVWF 0x30
    BTFSC 0x03,0
    INCF  0x26,1
    BCF   0x03,0
    MOVLW d'0'
    MOVWF 0x32
    MOVLW d'221'
    MOVWF 0x27
    ADDWF 0x26,0
    MOVWF 0x31
    BTFSC 0x03,0
    INCF  0x32,1
    BCF   0x03,0
    
    nop
    end
    