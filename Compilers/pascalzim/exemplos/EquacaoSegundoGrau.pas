// -------------------------------------------------------------
// Este programa calcula as raizes de uma equação de segundo 
// grau, segundo a conhecida formula de Baskara :~
// Autor : Luiz Reginaldo - Desenvolvedor do Pzim
// -------------------------------------------------------------

Program EquacaoSegundoGrau ;
 var a, b, c : integer ;
     delta, x1, x2 : real ;
 Begin
   writeln('Raizes da equacao ax^2 + bx + c = 0');
    
   // Solicita os valores de a, b e c
   write('Entre com o valor de a : ');
   read( a ); 
   write('Entre com o valor de b : ');
   read( b ); 
   write('Entre com o valor de c : ');
   read( c );    
   
   // Calcula o valor de delta
   delta := sqr(b) - 4*a*c ;
   writeln('Delta = b^2 - 4ac') ;
   writeln('O valor de delta = ', delta );
   
   // Verifica se existem raizes reais
   if( delta < 0 ) then
   Begin
     writeln('Porque delta e menor do que zero, nao existem raizes reais.');
   End;
   
   // Verifica se só tem uma raiz
   if( delta = 0 ) then
   Begin
     writeln('Para delta = 0 so existe uma raiz real, x1') ;
     writeln('Nesse caso x1 = -b/2a ');
     x1 := -b / (2*a) ;
     writeln('O valor de x1 = ', x1 );
   End ;
   
   // Verifica se existem duas raizes
   if( delta > 0 ) then
   Begin
     writeln('Para delta > 0 existem duas raizes reais, x1 e x2') ;
     writeln('Nesse caso x1 = (-b + raiz(delta)) / 2a ');
     writeln('Nesse caso x1 = (-b - raiz(delta)) / 2a ');
     x1 := (-b + sqrt(delta)) / (2*a) ;
     x2 := (-b - sqrt(delta)) / (2*a) ;     
     writeln('O valor de x1 = ', x1 );
     writeln('O valor de x2 = ', x2 );     
   End ;
  
 End.
