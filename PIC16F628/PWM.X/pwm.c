/*
 * File:   pwm.c
 * Author: Alejandro Gomez
 *
 * Created on 7 de octubre de 2019, 8:28
 */


#include "configurationBits.h"
#include <pic16f628.h>
#define _XTAL_FREQ 1000000
//600u el ciclo de trabajo
//1ms periodo
void main(void) {
    CCP1CON = 0;
    TMR2 = 0;
    PR2 = 0x7F;
    INTCON = 0 ;
    PIE1 = 0;
    CCPR1L = 0x1F; // PONEMOS UN
    TRISB3 = 0; //RB3 como salida
    //T2CON = 4; // activo preescalador de tmr2 con incremento de 1 en 1
    PIR1 = 0;
    CCP1CON = 0x2C;
    TMR2ON = 1;
    while(TMR2IF==0){
    }
    TMR2IF = 0;
    return;
}
