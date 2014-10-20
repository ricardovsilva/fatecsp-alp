// -------------------------------------------------------------
// Programa que mostra na tela a bandeira holandesa.
//
// Desenvolvido pelo beta-tester Danilo Rafael Galetti :~
// -------------------------------------------------------------

Program Pzim ;
var i: integer;
Begin
  // Imprime faixa azul
  For i:=1 to 640 do begin
    textcolor (lightblue);
    write (#178); 
  End;
  // Imprime faixa branca  
  For i:=1 to 720 do begin
    textcolor (white);
    write (#178); 
  End;
  // Imprime faixa vermelha  
  For i:=1 to 640 do begin
    textcolor (red);
    write (#178); 
  End;
End.
