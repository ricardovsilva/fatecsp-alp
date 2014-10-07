// -------------------------------------------------------------
// Este programa mostra o uso de matrizes.
//
// Problema. Ler uma matriz 3 x 3, multiplicar a diagonal 
// principal por uma constante K, que também deve ser lida. 
// Imprimir a matriz original, e a matriz modificada. :~
// -------------------------------------------------------------
                    
 Program ExemploPzim ;
 var i,j,k: integer;
     M: array [1..4, 1..4] of integer;
  Begin

  // Leitura dos dados da matriz
  For i:= 1 to 3 do     
   For j:= 1 to 3 do
     Begin
       write('Entre com o valor M[',i, ',',j, '] : '); 
       readln(M[i,j]);
     End; 
   
  
  // Leitura da constante K 
  write('Entre com um valor K : '); 
  readln(k);

  // Mostra matriz original 
  writeln('Matriz original : '); 
  For i:= 1 to 3 do
    writeln(M[i,1]:4, M[i,2]:4, M[i,3]:4);
 
  // Altera matriz original
  For i:= 1 to 3 do     
    M [ i, i ] := K * M [ i, i ] ;
                                  
  // Imprime a matriz modificada
  writeln('Nova Matriz : '); 
  For i:= 1 to 3 do
    writeln(M[i,1]:4, M[i,2]:4, M[i,3]:4);

 End.
