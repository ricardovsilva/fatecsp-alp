// -------------------------------------------------------------
// Este programa ilustra a alocacao dinamica com ponteiros.
//
// Problema. Alocar memória para um ponteiro, guardar nele
// um valor, depois colocar este valor em uma variável. :~
// -------------------------------------------------------------

Program ExemploPzim ;
Var p: ^integer;
    v : integer ;
 Begin
   new( p );   // Aloca memória para armazenar um inteiro
   p^ := 10 ;  // Guarda um inteiro na posição apontada por p

   writeln( 'Valor armazenado na posicao de memoria: ', p^ );

   v:= p^ ;    //Guarda em v o inteiro apontado por p

   writeln( 'Valor armazenado em v: ', v );

   dispose( p );  // Libera a memoria amarrada a p
   readln ;
 End.
