// -------------------------------------------------------------
// Programa que mostra na tela a bandeira italiana.
//
// Desenvolvido pelo beta-tester Danilo Rafael Galetti :~
// -------------------------------------------------------------

Program Pzim ;
var linha, coluna: integer;
Begin
 // Percorre cada linha da tela de impressao...
 For linha:= 1 to 25 do 
 Begin
    // Imprime parte verde
    For coluna:= 1 to 25 do 
    Begin
      gotoxy(coluna,linha);
      textcolor (lightgreen);
      write (#178);
    end;
    // Imprime parte branca
    For coluna:= 26 to 54 do 
    Begin
  	 gotoxy(coluna,linha);
 	 textcolor (white);
 	 write (#178);
   End;
   // Imprime parte vermelha   
   For coluna:= 55 to 80 do 
   Begin
      gotoxy(coluna,linha);
      textcolor (red);
      write (#178);
   End;
 end; 
End.
