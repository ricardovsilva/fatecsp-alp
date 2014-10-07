// -------------------------------------------------------------
// Programa que mostra a série de Fibonacci até o termo informado 
// pelo usuário. Na série de Fibonacci cada elemento é dado pela 
// soma dos 2 anteriores. :~
//
// Autor   : Rodrigo Garé Pissarro - Beta Tester
// Contato : rodrigogare@uol.com.br
// -------------------------------------------------------------

Program ExemploPzim ;
Var anterior1, anterior2, proximo: integer ;
    i: integer ;
    N: integer;
 Begin
     // Solicita o número de elementos da série
 	write('Informe o valor de N: ');
 	readln(N);
 	
	// Imprime primeiros dois elementos da série
 	anterior1:=1;
 	anterior2:=1;
 	write('1 1');
 	
 	// Cálculo da série  	
 	i:=3;  	
	while ( i <= N ) do begin
   		proximo:= anterior1 + anterior2;
     	write(' ', proximo);
     	anterior2:= anterior1;
     	anterior1:= proximo;  
     	i:= i+1;
	end;
 End.          
