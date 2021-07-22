/*
 * File:   2Display_0a99_TMR0_enC.c
 * Author: Alejandro Gomez
 *
 * Created on 29 de abril de 2021, 15:31
 */
// CONFIG
#pragma config FOSC = INTOSCCLK // Oscillator Selection bits (INTOSC oscillator: CLKOUT function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
#pragma config WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled)
#pragma config PWRTE = OFF      // Power-up Timer Enable bit (PWRT disabled)
#pragma config MCLRE = ON       // RA5/MCLR/VPP Pin Function Select bit (RA5/MCLR/VPP pin function is MCLR)
#pragma config BOREN = ON       // Brown-out Detect Enable bit (BOD enabled)
#pragma config LVP = OFF        // Low-Voltage Programming Enable bit (RB4/PGM pin has digital I/O function, HV on MCLR must be used for programming)
#pragma config CPD = OFF        // Data EE Memory Code Protection bit (Data memory code protection off)
#pragma config CP = OFF         // Flash Program Memory Code Protection bit (Code protection off)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#include <xc.h>
#define _XTAL_FREQ 4000000

// Esta función regresa el codigo a poner en el PORTB para que se muestre el numero del 0 al 9 recibido como argumento
int poner_numero_en_pantalla(int numero);

void main(void) {
    
    CMCON = 0x07; // Desabilitar comparadores (cuendo usor el puerto A) por defaul están activados.
    OPTION_REG = 0x38; // Configuración del TMR0
    TRISB = 0; // Configuro todo el puerto B como salida
    TRISAbits.TRISA4 = 1; // Configuro el RA4 como entrada porque es el boton del TMR0
    TRISAbits.TRISA7 = 0; // Configuro como salida el RA7 destinado a controlar la pantalla de decenas
    TRISAbits.TRISA0 = 0; // Configuro como salida el RA4 destinado a controlar la pantalla de unidades
    
    TMR0 = 0; //Limpio el TMR0
    PORTB = 0; // Apagamos todo el puerto B antes de comenzat
    // Defino contadores
    int contador_unidades = 0, contador_decenas = 0;          
    
    // Ciclo principal
    while(1){
        PORTB = 0;
        if(TMR0 < 100){
            contador_unidades = TMR0%10; // Si TMR0 = 56; esta instrucción me da el numero 6
            contador_decenas = (int)(TMR0/10); // Si TMR0 = 56; esta instrucción me da el numero 5
            
            PORTAbits.RA0 = 1; // prendo la pantalla de unidades
            PORTAbits.RA7 = 0; // apago la pantalla de decenas
            
            // Mando lo que tiene contador_unidades (que es un numero entre 0 y 9) a la función para que
            // regrese un numero entero con el codigo que hay que poner en el puerto B para
            // que se muestre el numero en el Display
            PORTB = 0;
            PORTB = poner_numero_en_pantalla(contador_unidades); // Pongo numero en pantalla de unidades
            // Nos esperamos un milisegundo (para lo del multiplexado)
            __delay_ms(1);
            PORTAbits.RA0 = 0;      // Apagamos la pantalla de unidades
            PORTB = 0;   // Apagamos todo el puerto B
            PORTAbits.RA7 = 1; // Prendo la pantalla de decenas
            PORTB = poner_numero_en_pantalla(contador_decenas); // Pongo numero en pantalla de decenas
            __delay_ms(1);  // Esperamos un milisegundo (para lo del multiplexado)
            PORTAbits.RA7 = 0; // Apago la pantalla de decenas
        }
    }
    return;
}

int poner_numero_en_pantalla(int numero){
    // Esta variable controla el numero a poner en pantalla
    int codigo_para_display = 0;
    // Elegimos el codigo correspondiente al numero 
    switch(numero){
        case 0: 
            codigo_para_display = 0b00111111;
            break;
        case 1: 
            codigo_para_display = 0b00000110;
            break;
        case 2: 
            codigo_para_display = 0b01011011;
            break;
        case 3: 
            codigo_para_display = 0b01001111;
            break;
        case 4: 
            codigo_para_display = 0b01100110;
            break;
        case 5: 
            codigo_para_display = 0b01101101;
            break;
        case 6: 
            codigo_para_display = 0b01111101;
            break;
        case 7: 
            codigo_para_display = 0b00000111;
            break;
        case 8: 
            codigo_para_display = 0b01111111;
            break;
        case 9: 
            codigo_para_display = 0b01100111;
            break;
        default:
            break;
    };
    
    return codigo_para_display; 
}
