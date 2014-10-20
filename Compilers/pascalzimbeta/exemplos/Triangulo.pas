// -------------------------------------------------------------
// Programa em que o usuário informa os 3 lados de um triângulo
// e ele informa o tipo de triângulo. :~ 
//
// Autor   : Rodrigo Garé Pissarro - Beta Tester
// Contato : rodrigogare@uol.com.br
// -------------------------------------------------------------
                 
Program ExemploPzim ;
Var X, Y, Z: real;

 Begin
     // Solicita os valores de x, y e z
	write('Informe o valor do lado X: ');
	readln(x);
	write('Informe o valor do lado Y: ');
	readln(y);
	write('Informe o valor do lado Z: ');
	readln(z);
	
	// Imprime o tipo de triângulo
	if (x<=0) or (y<=0) or (z<=0) then 
	  begin
		writeln('Um triângulo não pode ter lados nulos ou negativos');
	  end 
	else if (X>(Y+Z)) or (Y>(X+Z)) or (Z>(X+Y)) then
	  begin
	  	writeln(X:1:0,', ',Y:1:0,' e ',Z:1:0,' não são lados de um triângulo.');
	  end  
	else if (x=y) and (y=z) then 
  	  begin
		write ('O triângulo é equilátero');
	  end 
	else if (x=y) or (x=z) or (y=z) then 
	  begin
		write ('O triângulo é isósceles');
	  end 
	else 
	  begin
		write('O triângulo é escaleno');
	  end;
 End.
