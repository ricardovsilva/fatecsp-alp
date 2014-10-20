// -------------------------------------------------------------
// Programa que troca os valores de duas variáveis, a e b. :~
// -------------------------------------------------------------

Program ExemploPzim ;
 var a,b: integer;
 Begin

  // Solicita valores de a e b
  writeln('Digite dois valores inteiros:');
  write('Valor de a: ');
  readln(a);
  write('Valor de b: ');
  readln(b);

  // Troca dos valores de a e b
  a:= a+b;
  b:= (a-b);
  a:= (a-b);
  writeln('Os valores foram trocados');
  writeln('-------------------------');
  writeln('Valor de a = ',a);
  writeln('Valor de b = ',b);

 End.
