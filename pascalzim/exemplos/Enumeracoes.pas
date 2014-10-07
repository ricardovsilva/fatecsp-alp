// -------------------------------------------------------------
// Este programa ilustra a utilização de enumeracoes. :~
// -------------------------------------------------------------

Program ExemploPzim ;
 var diasSemana : (domingo, segunda, terca, quarta, quinta, sexta, sabado) ;
 Begin
   writeln( 'Depois de segunda vem quinta? ' , succ(segunda) = quinta  );
   writeln( 'Depois de segunda vem terca? '  , succ(segunda) = terca  );
   writeln( 'Antes de quinta vem quarta? '   , pred(quinta) = quarta  );
   writeln( 'Antes de quinta vem segunda? '  , pred(quinta) = segunda  );
 End.
