// -------------------------------------------------------------
// Este programa mostra a utilização de enumeracoes nos comandos
// for e case. :~
// -------------------------------------------------------------

Program ExemploPzim ;
 Type diaSemana = ( domingo, segunda, terca, quarta, quinta, sexta, sabado ) ;
 Var dia : diaSemana  ;
 Begin
   for dia := domingo to sabado do
   begin
     case ( dia ) of     
	   domingo: writeln( 'O dia é domingo' ) ;
        segunda: writeln( 'O dia é segunda' ) ;
        terca  : writeln( 'O dia é terca' ) ;
        quarta : writeln( 'O dia é quarta' ) ;
        quinta : writeln( 'O dia é quinta' ) ;
        sexta  : writeln( 'O dia é sexta' ) ;
        sabado : writeln( 'O dia é sabado' ) ;                      
      end;
   end;
   readkey;
 End.
