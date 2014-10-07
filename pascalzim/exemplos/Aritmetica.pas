// -------------------------------------------------------------
// Programa que realiza operações aritméticas usando dados 
// fornecidos pelo usuário. :~
//
// Autor   : Rodrigo Garé Pissarro - Beta Tester
// Contato : rodrigogare@uol.com.br
// -------------------------------------------------------------

Program ExemploPzim ;
 Var valor1, valor2: Integer;
 Begin
      // Solicita dois valores ao usuário
      write('Informe o primeiro Valor: ');
      readln(valor1);
      write('Escreva o segundo Valor: ');
      readln(valor2);
            
      // Mostra resultado de operações aritméticas      
      writeln('a) Soma dos dois números: ', valor1+valor2);
      writeln('b) Subtração do primeiro pelo segundo: ', valor1-valor2);
      writeln('c) Subtração do segundo pelo primeiro: ', valor2-valor1);
      writeln('d) Multiplicação dos dois números: ', valor1*valor2);
      writeln('e) Resto da divisão do primeiro pelo segundo: ', valor1 mod valor2);
      writeln('f) Resto da divisão do segundo pelo primeiro: ', valor2 mod valor1);
 End.
