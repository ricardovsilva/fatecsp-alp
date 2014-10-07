// -------------------------------------------------------------
// Este programa mostra como definir uma função recursiva.
// O programa solicita a entrada de n, e calcula n! :~
// -------------------------------------------------------------

Program ExemploPzim ;
 Var n: integer;

 // Função recursiva que, dado n, retorna n!     
 Function Fatorial(n:integer): integer ;
  Begin
   if n > 1 then
     Fatorial := n * Fatorial(n-1)
   else 
     Fatorial:= 1;
  End;

 // Corpo do programa principal
 Begin  
  write('Entre com o valor de n: ');
  readln(n);
  writeln('Valor de fat(n) => ', Fatorial(n));
  readkey;
 End.
