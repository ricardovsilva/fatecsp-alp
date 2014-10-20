// -------------------------------------------------------------
// Este programa simule a rolagem de dois dados de 6 faces,
// para depois calcular a soma dos numeros obtidos :~
// Autor : Luiz Reginaldo - Desenvolvedor do Pzim
// -------------------------------------------------------------

Program RolagemDados ;
 var primeiroDado : integer ;
     segundoDado : integer ;
     soma : integer ;
 Begin
   randomize ;
   
   // Rola os dados
   primeiroDado := random(7);
   segundoDado := random(7) ;
   soma := primeiroDado + segundoDado ;
   
   // Mostra resultados
   writeln('Primeiro dado => ', primeiroDado );
   writeln('Segundo dado => ', segundoDado );
   writeln('Soma dos dados => ', soma );
  
 End.
