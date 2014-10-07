// -------------------------------------------------------------
// Programa que mostra a utilização de ponteiros.
//
// Problema. Alterar o valor armazenado em uma variável usando
// um ponteiro que aponta para o endereço dessa variável. :~
// -------------------------------------------------------------

Program ExemploPzim ;
Var  a: integer;
     p: ^integer;
 Begin
    a := 8 ;    // Guarda o valor 8 em a
    p := nil;   // O ponteiro não guarda nenhum endereço 
    writeln( 'Valor armazenado em a: ' , a );
    
   // Guarda no ponteiro o endereço da variável a
   p := @a ;
   writeln( 'Valor apontado por p: ' , p^ );
   
   // O comando abaixo é equivalente a “a:= 2 * a ;” , pois p
   // guarda o endereço de a (p aponta para a)
   a:= 2 * p^ ;
   writeln( 'O valor de a agora: ' , a );     // Imprime 16
   writeln( 'Valor apontado por p: ' , p^ );  // Imprime 16
   readln ;
 End.
