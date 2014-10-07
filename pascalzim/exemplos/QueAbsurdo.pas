// -------------------------------------------------------------
// Este programa mostra a definição de um tipo de dados bem
// complexo. Esse tipo de dados é utilizado para definição e 
// uso de uma variável de exemplo. :~
// -------------------------------------------------------------

Program ExemploPzim ;

 TYPE TIPO_ABSURDO = array[1..4] of record
                                      campo1: integer;
                                      campo2: array[1..4] of array [1..2,1..3] of integer;
                                      campo3 : record
                                                 novo_campo : integer;
                                               end;
                     end;

 VAR absurdo: array[1..4,1..5] of TIPO_ABSURDO;

 Begin
    absurdo[1,2,3].campo2[1,2][3] := 5;
    write('A variavel absurdo guarda o valor: ', absurdo[1][2,3].campo2[1,2,3]);
    readkey;
 End.
