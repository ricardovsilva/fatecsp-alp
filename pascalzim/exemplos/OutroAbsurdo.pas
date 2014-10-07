// -------------------------------------------------------------
// Este programa mostra a definição de um tipo de dados bem
// complexo. Esse tipo de dados é utilizado para definição e uso
// de uma variável de exemplo. :~
// -------------------------------------------------------------

Program ExemploPzim ;

 TYPE TIPO_ABSURDO = array[1..4] of record 
                       campo1: integer;
                       campo2: array[1..4] of array [1..2,1..3] of string[11];
                       campo3 : record 
                                  novo_campo : integer;
                                end;
                     end; 

 VAR absurdo : array[1..4,1..5] of TIPO_ABSURDO;


 Begin
  absurdo[1,2][3].campo2[1,2][3] := 'Pascal ZIM!';
  writeln('A variavel absurdo guarda o valor: ***', absurdo[1,2,3].campo2[1][2][3],'***');

  writeln('=>Posicao 1  :***', absurdo[1][2][3].campo2[1][2,3][1],'***');  
  writeln('=>Posicao 2  :***', absurdo[1,2][3].campo2[1][2,3][2],'***'); 
  writeln('=>Posicao 3  :***', absurdo[1][2,3].campo2[1][2,3][3],'***'); 
  writeln('=>Posicao 4  :***', absurdo[1,2,3].campo2[1][2,3][4],'***');  
  writeln('=>Posicao 5  :***', absurdo[1][2][3].campo2[1][2][3][5],'***');   
  writeln('=>Posicao 6  :***', absurdo[1][2][3].campo2[1,2][3][6],'***'); 
  writeln('=>Posicao 7  :***', absurdo[1,2][3].campo2[1][2,3][7],'***');  
  writeln('=>Posicao 8  :***', absurdo[1][2,3].campo2[1][2][3,8],'***'); 
  writeln('=>Posicao 9  :***', absurdo[1,2,3].campo2[1,2,3][9],'***');  
  writeln('=>Posicao 10 :***', absurdo[1][2][3].campo2[1][2,3,10],'***'); 
  writeln('=>Posicao 11 :***', absurdo[1,2,3].campo2[1,2,3,11],'***');  
 
  readkey;
 End.
