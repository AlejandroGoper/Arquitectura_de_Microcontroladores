#include <xc.inc>

/*
    En las nuevas versiones de MPLAB se utiliza este codigo como sustituto 
    al de suma del archivo, suma1.asm
    
	*/
	
psect	absdata,abs,ovrld
	org	0x00
	goto	main
	org	0x05
psect	code
main:
    movlw   87
    addlw   15
    nop
    END