/*
 * File:   teclado_matricial.c
 * Author: Alejandro Gomez
 *
 * Created on 1 de mayo de 2021, 5:38
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


// Defino las variables globales que controlan las filas y columnas del teclado matricial
#define Y_1    PORTAbits.RA3
#define Y_2    PORTAbits.RA2
#define Y_3    PORTAbits.RA1
#define Y_4    PORTAbits.RA0
#define X_1    PORTBbits.RB2
#define X_2    PORTAbits.RA7
#define X_3    PORTBbits.RB0
#define X_4    PORTBbits.RB1

// Estas dos funciones son para elegir que tecla se ha presionado en el teclado matricial
char tecla_presionada(void);
char checar(void);

/* Recordemos que para usar un teclado matricial, las filas deben configurarse como salidas
 y las columnas como entradas, con esto, básicamente cuando se pulsa un botón, debemos verificar
 en que columna se ha activado el paso de corriente ¿Cómo lo hacemos? Pues vamos apagando todas
 las filas y dejamos solo una activada y verificamos sobre las columnas (que van conectadas a pines configurados como entrada)
 y asi vemos que pin es el que esta activo y ubicamos entonces que tecla se ha presionado */

void main(void) {
    CMCON = 0x07; // Desactivo los comparadores porque por default estan activados (esto es para el puerto A)
    OPTION_REG = 0; // Desactivo todos los timers
    // Configuro los pines de entrada y salida para el teclado matricial 
    
    TRISBbits.TRISB0 = 0;
    TRISBbits.TRISB1 = 0;
    TRISBbits.TRISB2 = 0;
    TRISAbits.TRISA7 = 0;
    TRISAbits.TRISA0 = 1;
    TRISAbits.TRISA1 = 1;
    TRISAbits.TRISA2 = 1;
    TRISAbits.TRISA3 = 1;
    // Este puerto controlara el led, por lo tanto es salida
    TRISBbits.TRISB3 = 0;
    // Estas variables son para la contraseña
    char c = ' ',pass[5] = "_____";
    int contador = 0;
    PORTBbits.RB3 = 0;
    while(1){
        //PORTBbits.RB3 = 0;
        // Verificamos primero si alguna columa ha captado alguna señal
        if(Y_1 == 1 || Y_2 == 1 || Y_3 == 1){
            // Si se ha presionado cualquier tecla, alguna de las columnas habra dejado
            // pasar corriente y se activara el pin corresponiente, debemos checar cual, con la siguiente funcion
            c = tecla_presionada();
            // Incrementamos el contador en 1 porque ya se ha presionado la tecla una vez
            contador+=1;
            // En este arreglo vamos escribiendo el codifo de acceso letra por letra en cada indice del arreglo
            pass[contador] = c;
            
            // Verificamos si la contraseña es correcta
            // en este caso la contraseña es: 123*
            if(pass[0] == '_' && pass[1] == '1' && pass[2] == '2' && pass[3] == '3' && pass[4]=='*'){
                // Si la contraseña es correcta, prendemos un LED en RB3
                PORTBbits.RB3 = 1;
                // Nos esperamos 1 segundo 
                __delay_ms(1000);
                // Apagamos el LED
                PORTBbits.RB3 = 0;
                contador = 0;
            }
            if((pass[0] != '_' || pass[1] != '1' || pass[2] != '2' || pass[3] != '3'|| pass[4]!= '*') &&  contador == 4){
                // Si la contraseña es incorrecta no hace nada
                //PORTBbits.RB3 = 0;
            }
        }
        else{
            // Si no se ha presionado nada, mandamos 1 a todos los puertos que controlan las filas del teclado matricial
            // para que en caso de que se presione alguna, podamos detectar la señal
            X_1 = 1;
            X_2 = 1;
            X_3 = 1;
            X_4 = 1;
            //PORTBbits.RB3 = 0;
        }
    }
    return;
}

/*
 Esta función se ejecuta mientras el dedo este presionando la tecla correspondiente
 esta diseñada para que se eviten los rebotes de los botones o que se capte más de una vez
 la misma tecla si se deja presionado el dedo
 */
char tecla_presionada(void){
	char Key;
	Key = 'n';
	while(Key == 'n'){
		Key = checar();	
	}
	return Key;
}

/*
 *Esta función es la que busca e identifica que tecla se ha presionado alguna tecla
 * se presiona.
 */
char checar(void){
    // Apagamos todas las filas menos la primera
	X_1 = 1; X_2 = 0; X_3 = 0; X_4 = 0;
    // Verificamos en que columna hay paso de corriente para identificar la tecla
    if (Y_1 == 1){ __delay_ms(100); /*while (Y_1==1){}*/ return '1'; }
    if (Y_2 == 1){ __delay_ms(100); /*while (Y_2==1){}*/ return '2'; }
    if (Y_3 == 1){ __delay_ms(100); /*while (Y_3==1){}*/ return '3'; }
    //if (Y_4 == 1){ __delay_ms(100); while (Y_4==1){} return 'A'; }
    // Ahora apagamos todas las filas menos la segunda y repetimos el proceso anterior
    X_1 = 0; X_2 = 1; X_3 = 0; X_4 = 0;    
    if (Y_1 == 1){ __delay_ms(100); /*while (Y_1==1){}*/ return '4'; }
    if (Y_2 == 1){ __delay_ms(100); /*while (Y_2==1){}*/ return '5'; }
    if (Y_3 == 1){ __delay_ms(100); /*while (Y_3==1){}*/ return '6'; }
    //if (Y_4 == 1){ __delay_ms(100); while (Y_4==1){} return 'B'; }
            
    X_1 = 0; X_2 = 0; X_3 = 1; X_4 = 0;    
    if (Y_1 == 1){ __delay_ms(100); /*while (Y_1==1){}*/ return '7'; }
    if (Y_2 == 1){ __delay_ms(100); /*while (Y_2==1){}*/ return '8'; }
    if (Y_3 == 1){ __delay_ms(100); /*while (Y_3==1){}*/ return '9'; }
    //if (Y_4 == 1){ __delay_ms(100); while (Y_4==1){} return 'C'; }
           
    X_1 = 0; X_2 = 0; X_3 = 0; X_4 = 1;    
    if (Y_1 == 1){ __delay_ms(100); /*while (Y_1==1){}*/ return '*'; }
    if (Y_2 == 1){ __delay_ms(100); /*while (Y_2==1){}*/ return '0'; }
    if (Y_3 == 1){ __delay_ms(100); /*while (Y_3==1){}*/ return '#'; }
    //if (Y_4 == 1){ __delay_ms(100); while (Y_4==1){} return 'D'; }
    // Si no se cumplió ninguna condición, se regresa 'n'
    return 'n';     
}
