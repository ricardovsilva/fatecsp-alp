// -------------------------------------------------------------
// Programa com a fórmula matemática para se calcular Pi. Quanto 
// maior o número n, mais próximo será o resultado entre o valor 
// calculado pelo programa e o número Pi. Como o programa é 
// bastante limitado, esse resultado não se aproxima tanto. 
// Quanto mais tendente ao infinito for o número n,  mais fiel 
// será o valor final apresentado pelo programa em relação ao 
// valor de Pi. A expressão matemática usada nesse programa é 
// a seguinte: 
//
// Pi = 3 + 1/2 - 1/3 + 1/4 - 1/5 + 1/6 ...
//
// Obs: Pi= 3,14159265358979........
//
// Desenvolvido pelo beta-tester Danilo Rafael Galetti :~
// -------------------------------------------------------------

Program Pzim ;
var i,n: integer;
    Pi: real;

Begin
 // Solicita o numero de termos da série
 write('Informe o numero de termos da serie: ');
 read(n);
 
 // Caclula o valor de PI
 Pi:=3;
 For i:=2 to n do
 Begin
   // Os termos na posicao par sao positivos
   if (i mod 2 = 0) then
   	 Pi:= Pi+(1/i);
   // Os termos na posicao impar sao negativos
   if (i mod 2 <> 0) then
      Pi:= Pi-(1/I);
 End;
		write ('Número Pi é igual à ',Pi);
End.
