// -------------------------------------------------------------
// Programa que simula um cromômetro fazendo contagem regressiva
//
// Desenvolvido pelo beta-tester Danilo Rafael Galetti :~
// -------------------------------------------------------------

Program Pzim ;
var tempo:integer;
Begin
  // Solicita o tempo para o cronometro
  write ('Digite o tempo que você deseja que o programa cronometre (s): ');
  read (tempo);
 
  // Repeticao até o tempo chegar em zero
  while (tempo<>0) do
  Begin
    delay (1000);    
    clrscr;
    writeln ('Cronometrando: ',tempo,' segundos');
    tempo := tempo - 1;
  End;
  
  writeln ('');
  Write ('     Tempo esgotado !');
End.
