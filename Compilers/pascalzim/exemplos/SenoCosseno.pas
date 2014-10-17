// ----------------------------------------------------------------
// Programa em que o usuário informa o valor de um ângulo em graus
// e o programa informa o seno e o cosseno deste ângulo.
// 
// OBS: As funções Sin() e Cos() esperam um angulo em radianos. :~
//
// Autor   : Rodrigo Garé Pissarro - Beta Tester
// Contato : rodrigogare@uol.com.br
// ----------------------------------------------------------------
Program ExemploPzim ;
Var graus: real;
    grausRadiano: real;
 Begin
      // Solicita o valor do angulo
      write('Informe o valor do ângulo em graus: ');
      readln(graus);
      
      // Mostra o seno e o cosseno
      grausRadiano:= graus*(3.1415/180) ;
      writeln('O Seno do ângulo é: ', sin(grausRadiano):2:2);
      writeln('O Cosseno do ângulo é: ', cos(grausRadiano):2:2);
 End.
