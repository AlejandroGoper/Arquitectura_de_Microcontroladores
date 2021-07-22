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
    movlw   87	    ;Mueve literal a Wreg
    addlw   15	    ;Suma literal a W, se pierde lo que ya tenía W antes
    nop		    ;Nada
    END		    ;Fin

/*
    Para ver el funcionamiento, hay que ir a DEBUG,
     luego a Variables,
     seleccionar WREG 
     y ver que efectivamente se realice la suma
     
     **cambiar la visualización de WREG a decimal.
    */