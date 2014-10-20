// ----------------------------------------------------------------
// Este programa informa o dia da semana que corresponde a uma
// data informada pelo usuario :~
// Autor : Luiz Reginaldo - Desenvolvedor do Pzim
// -------------------------------------------------------------

Program CalculaDiaSemana ;

var
   dia, mes, ano : integer ; // dados informados pelo usuario
   diaAux, mesAux, anoAux, seculo: integer; // auxiliares
   diaSemana: string[15] ; // Nome do dia da Semana

Begin
   // Solicita ao usuario o dia 
   write('Digite o dia: ');
   read(dia);
   while (dia < 1) or (dia > 31) do
   Begin
     write('diaAux invalido, informe novamente');
     read(dia);
   End;

   // Solicita ao usuario o mes
   write ('Digite o mes: ');
   read (mes);
   while (mes < 1) or (mes > 12) do
   Begin
     write('Mes Invalido, informe novamente');
     read(mes);
   End;

   // Solicita ao usuario o ano
   write ('Digite o Ano: ');
   read (ano);
   while (ano < 1) or (ano > 9999) do
   Begin
     write('Ano invalido, informe novamente ');
     read(ano);
   End;

   // Obtem valores para calcular o dia da semana
   seculo:= ano div 100;
   anoAux:= ano mod 100;
   If mes <= 2 then
   Begin
      mesAux:= mes + 10;
      anoAux:= anoAux -1;
   End
   Else mesAux:= mes -2;
   
   //  Calcula o dia da semana
   diaAux := (Trunc(2.6 * mesAux -0.1) + dia + anoAux + anoAux div 4 + seculo div 4 - 2 * seculo) mod 7;
   if diaAux < 0 then diaAux:= diaAux + 7;      
   
   // Determina o dia da semana
   case diaAux of
     0 : diaSemana:= 'Domingo';
     1 : diaSemana:= 'Segunda-Feira';
     2 : diaSemana:= 'Terca-Feira';
     3 : diaSemana:= 'Quarta-feira';
     4 : diaSemana:= 'Quinta-Feira';
     5 : diaSemana:= 'Sexta-Feira';
     6 : diaSemana:= 'Sabado';
   end ;   

   // Exibe resultados na tela
   writeln ;
   writeln('=> A data informada foi : ', dia, '/', mes, '/', ano);
   writeln('=> Dia da semana : ', diaSemana) ;    

End.
