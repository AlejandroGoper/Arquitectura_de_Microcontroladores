/*
 * File:   LDCmain.c
 * Author: Alejandro Gomez
 *
 * Created on 10 de octubre de 2019, 8:45
 */
#include <pic16f628.h>
#include "configurationBits.h"
#include "lcd.c"
#define _XTAL_FREQ 1000000

void main(void) {
    init_lcd();
}
