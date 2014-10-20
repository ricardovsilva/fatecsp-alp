// -------------------------------------------------------------
// Dadas duas matrizes A e B, programa calcula C = A + B. :~
// -------------------------------------------------------------

Program ExemploPzim ;

 Var A,B,C : array [ 1..2 , 1..4 ] of integer;
     i,j : integer;

 Begin

  // Leitura da matriz A 
  For i:= 1 to 2 do
    For j:= 1 to 4 do
     Begin
       write('Entre com o valor A[',i, ',',j, '] : '); 
       readln(A[i][j]);
     End; 
   

  // Leitura da matriz B 
  For i:= 1 to 2 do
    For j:= 1 to 4 do
     Begin
       write('Entre com o valor B[',i, ',',j, '] : '); 
       readln(B[i,j]);
     End; 
   
  // Calcula matriz C = A + B 
  For i:= 1 to 2 do
    For j:= 1 to 4 do
      C[i,j] := A[i,j] + B[i,j];

  // Impressao das matrizes
  writeln('Matriz A : '); 
  For i:= 1 to 2 do
    writeln(A[i,1]:4, A[i,2]:4, A[i,3]:4, A[i,4]:4);

  writeln('Matriz B : '); 
  For i:= 1 to 2 do
    writeln(B[i,1]:4, B[i,2]:4, B[i,3]:4, B[i,4]:4);


  writeln('Matriz C : '); 
  For i:= 1 to 2 do
    writeln(C[i,1]:4, C[i,2]:4, C[i,3]:4, C[i,4]:4);
    
 End.
