// -------------------------------------------------------------
// Programa que caclula o índice de massa corporal.
//
// Desenvolvido pelo beta-tester Danilo Rafael Galetti :~
// -------------------------------------------------------------

Program Pzim ;
var peso,altura,imc,fim: Real;

Begin
  // Solicita a altura
  write ('Informe a sua altura (em m): ');
  read(altura);
 
  // Solicita o peso
  write('Informe o seu peso: ');
  read(peso);
 
  // Calcula o indice de massa corporal, mostra resultados
  imc:=peso/(altura*altura);
  writeln( 'Seu imc = ', imc );

  if (imc<18.5) then
  Begin
    writeln('');
    writeln('Você está abaixo do peso recomendado.');
  End;

  if (imc>=18.5) and (imc<25) then
  Begin
    writeln('');
    writeln('Você está com o peso normal.');
  End;

  if (imc>=25) and (imc<30) then
  Begin
    writeln('');
    writeln('Você está com sobrepeso.');
  End;

  if (imc>=30) and (imc<40) then
  Begin
    writeln('');
    writeln('Você está obeso.');
  End;

  if (imc>=40) then
  Begin
    writeln('');
    writeln('Você está com obesidade mórbida. Isso pode ser grave!');
  End;

  readkey ;
 End.
