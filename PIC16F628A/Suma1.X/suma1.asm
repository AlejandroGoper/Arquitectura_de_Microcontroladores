/*
    Este es un c�digo de ensamblador,
     Los c�digos de ensamblador se ordenan por columnas,
     La primer columa: Etiquetas
     La segunda columna: Mnemonico de las instrucciones (el nombre de la inst.)
     La tercer columna: Los argumentos de las instrucciones
     La cuarta columna: Comentarios del c�digo
    */

//Este prograa realiza la suma de dos n�meros	
	
	org	00h //Esto dice, que empezamos en la localidad 0x00 de memoria y que all� escriba...
	goto	inicio // Ve a la etiqueta inicio (que esta localizada en la 0x05)
	org	05h 
inicio:	movlw	87d	;Muevo o cargo el numero decimal 87 en el registro W
	addlw	15d	;Suma el n�mero decimal 15 con el decimal 87, el resultado lo deja en W
	
	nop		; No operation, sirve para el simulador, pero no hace nada.
	end		; Palabra reservada para decir que termino el programa

//Esto no jala, ver el archivo suma1.s