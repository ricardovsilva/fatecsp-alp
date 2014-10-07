// -------------------------------------------------------------
// Esse programa mostra o funcionamento da função keypressed. :~
// -------------------------------------------------------------

Program ExemploPzim ;
var coluna: integer ;
 Begin
    // Desenha um carrinho, que vai andando na tela, até o 
    // usuário pressionar alguma tecla 
    for coluna:= 5 to 50 do
    Begin
       clrscr ;
       gotoxy( 1, 2 );
       writeln( 'Bruum... Pressione uma tecla para parar...' );
       gotoxy( coluna, 7 );
       writeln( '  - ', #177, #177, #177, #177, #177, #177  );
       gotoxy( coluna, 8 );
       writeln( '- - ', #177, #177,  #177, #177, '  ', #177  );
       gotoxy( coluna, 9 );
       writeln( '- - ', #177, #177, #177, #177, #177, #177, #177, #177 );
       gotoxy( coluna, 10 );
       writeln( '    o     o' );
       writeln( '--------------------------------------------------------------');
       delay( 200 );
       if( keypressed ) then break ;
     End ;
 End.
