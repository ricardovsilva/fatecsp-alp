// -------------------------------------------------------------
// Este programa implementa um jogo espacial. :~
// Revisado por Luiz Reginaldo - Desenvolvedor do Pzim
// Autores: Marco André Dinis e José Luis Teixeira
// -------------------------------------------------------------
Program WordKill;
 
 var letra : char ;
     i : integer;

 //------------------------------------------------------------------- 
 // Desenha a tela inicial do jogo
 //------------------------------------------------------------------- 
 Procedure ExibeTelaInicial ;
 Begin
   textbackground(BLUE);
   textcolor(WHITE);
   clrscr;
   writeln('________________________________');
   writeln('|******************************|');
   writeln('|>--===^^   Word Kill  ^^===--<|');
   writeln('|******************************|');
   writeln('|______________________________|');
   writeln('v 0.1');
   writeln('Créditos: Marco André Dinis');
   writeln('          José Luis Teixeira');
   writeln('11 PTGEI Escola Secundária de');
   writeln('Amarante 2007/2008');
   writeln('Disciplina: SDAC');
   writeln('');          
   writeln('Este jogo é muito simples.');
   writeln('Quando aparecer uma letra no');
   writeln('ecrã você apenas precisa digitar');
   writeln('a letra correspondente no teclado');
   writeln('');
   writeln('Presione a tecla W para jogar');   
 End ;


 //------------------------------------------------------------------- 
 // Desenha a tela inicial do jogo
 //------------------------------------------------------------------- 
 Procedure DesenhaTabuleiro ;
 var i: integer ;
 begin
   clrscr;
   writeln('________________________________');
   for i:= 1 to 20 do
     writeln('|                              |');
   writeln('|              %               |');
   writeln('______________#',#1,'#_______________');
   writeln('Nivel:');
   writeln('Pontuação:');
 End;



 //------------------------------------------------------------------- 
 // Roda o jogo
 //------------------------------------------------------------------- 
 Procedure IniciaJogo ;
 var i, j: integer ;
     letra : char ;
     pontos, nivel: integer ;
     continuar : boolean ;     
     achouRepetido, acertouTodas : boolean ;
     sorteadas : array[1..7] of char ; // Letras sorteadas no nivel
     colSorteadas : array[1..30] of integer ; // coluna das letras          
 Begin
 
   // Valor inicial para as variaveis do jogo
   nivel := 1 ;
   pontos := 0 ;
   continuar := true ;
   
   randomize ;  
   Repeat
      // Desenha o tabuleiro do jogo
      DesenhaTabuleiro;
   
      // Informa em que nivel está o jogo
      gotoxy(8,24);
      write(nivel);
              
      // Sorteia as letras desse nível
      for i:= 1 to 7 do
      Begin
         j := random(25)+65;
         sorteadas[i] :=chr(j);
      End ;
         
      // Sorteia a coluna em que vai aparecer cada uma das letras sorteadas
      Repeat
         // Sorteia as colunas das letras
         for i:=1 to 7 do
            colSorteadas[i] := random(30) + 2;
               
         // Verifica se alguma coluna é repetida
         // Se for, um novo sorteiro vai ser feito
         achouRepetido := false ;
         for i:=1 to 7 do
           for j:=1 to 7 do
             if (i<>j) and (colSorteadas[i] = colSorteadas[j]) then 
			achouRepetido := true ;                                
                        
      Until not achouRepetido ;  
         
	 // Desenha as letras sorteadas na parte de cima da tela          
      for i:=1 to 7 do
      begin
         gotoxy(colSorteadas[i],2);
         write(sorteadas[i]);
      end;
   
      // Repeticao para descer as letras uma linha de cada vez
      for i:=1 to 20 do
      begin
        // Se usuario pressionou uma tecla verifica se essa
	   // tecla é alguma das sorteadas         
        if keypressed then
        begin
          letra := Upcase(readkey);            
          for j:=1 to 7 do
          begin
            if letra = sorteadas[j] then
            begin
              pontos := pontos + 10 ;
              sorteadas[j]:=' ';
              gotoxy(colSorteadas[i]+2,2+i);
              write (' ');
            end;
          end;      
        end;
            
	   // Informa a pontuacao	       
        gotoxy(12,25);
        write(pontos);  
             
	   // Desenha as letras sorteadas na proxima linha	         
        for j:=1 to 7 do
        begin
          gotoxy(colSorteadas[j],1+i);
          write(' ');
          gotoxy(colSorteadas[j],2+i);
          write (sorteadas[j]);
        end;
                                              
        // Verifica se acertou todas as letras sorteadas
	   acertouTodas := true ;
        for j:=1 to 7 do
        begin
          if sorteadas[j] <> ' ' then acertouTodas:= false ;
        end;
          
	   // Se acertou todas, passa para o proximo nivel	                 
        if acertouTodas then
        begin
          nivel := nivel + 1 ;
          break ;
        end;        
        
        // Se chegou na ultima linha sem acertar as letras termina o jogo
	   gotoxy(16,22);
        delay(600-(nivel*15));
        if (i=20) and (not acertouTodas) then 
	      continuar:=false;
      end;
      	 
   Until continuar=false;
   
   // Mostra a pontuacao final
   gotoxy(1,26);
   Writeln('A sua pontuação foi de:  ',pontos);
   Writeln('Chegaste ao nivel:       ',nivel);
   Writeln('Pressione <ENTER> para sair');
  end;
 

 //---------------------------------------------------------------- 
 // Inicio do jogo
 //---------------------------------------------------------------- 
 Begin
   // Mostra a tela inicial do jogo
   ExibeTelaInicial ;
   
   // Aguarda o usuário pressionar w para poder jogar
   repeat
      letra := upCase(ReadKey);
   until letra='W';
   
   // Desenha a faixa que corre da esquerda para direita
   writeln(#7,'A carregar...');
   for i:=1 to 32 do
   begin
      delay(50) ;
      write(#177) ;
   end;
   
   // Começa o jogo
   IniciaJogo ;
 End.
