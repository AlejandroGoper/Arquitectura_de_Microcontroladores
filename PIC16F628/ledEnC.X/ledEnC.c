/*
 * File:   ledEnC.c
 * Author: Alejandro Gomez
 *
 * Created on 30 de septiembre de 2019, 8:34
 */


#include "configurationBits.h"
#include <pic16f628.h>
#define _XTAL_FREQ 1000000

void main(void) {
    TRISA4 = 1; //RA4 entrada
    TRISA1 = 0; // RA1 salida led
    OPTION_REG = 0x38; // configuracion del TMR0
    if(TMR0 == 9){
    RA1 = 1; //encender led
    __delay_ms(10000);
    TMR0 = 0;
    }
    else{
        RA1 =0 ; // apagar
    }
    return;
}
