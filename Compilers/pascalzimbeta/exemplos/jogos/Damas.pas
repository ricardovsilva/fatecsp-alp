// -------------------------------------------------------------
//   Programa que implementa um jogo de damas :~
//   Damas - versão 1.0
//                                     
//   Autor : Guilherme Resende Sá 
//   Contato : gresendesa@gmail.com
//
// ------------------------------------------------------------- 
//  
//   Características
//   
//   O programa desenha um tabuleiro com as possíveis dimensões: 8x8, 10x10 e 12x12 
//   Agrega funções que permitem controlar todas as regras do jogo de damas
//   Os menus são exibidos em janelas simuladas
//   O jogo poderá ser realizado entre pessoas com computadores diferentes
//   ESTE CÓDIGO FOI PROJETADO PARA PASCAL ZIM 5.2
//
//   Nota: ESTE CÓDIGO É LIVRE E PODE SER REAPROVEITADO, MODIFICADO E APERFEIÇOADO
//         DESDE DE QUE SE FAÇA AS DEVIDAS CITAÇÕES AO AUTOR ORIGINAL.
//   
// ------------------------------------------------------------- 

Program Damas ;
uses crt ;
Const
COR_FUNDO = 16 ;
POS_COL_TABULEIRO = 16 ;
POS_LIN_TABULEIRO = 2 ;
V_1 = 1;
V_2 = 11;
V_1_D = 111;
V_2_D = 1111;
Var
tabuleiro : record //Definições do tabuleiro
              quantidadeCasas : integer ;
              cor1, cor2 : integer ;
              grade : array[1..12, 1..12] of integer ; 
              disposicao, pecaSelecionada, damaSelecionada, erro : boolean ;
              origemCol, origemLin, posColAtiva, posLinAtiva, oLin, oCol : integer;
		  end;
            
casa : record //Definições das casas do tabuleiro
         dimCol, dimLin : integer ;
       end;

jogador : record //Definições do jogador
            cor1, cor2 : integer;
            quantPecas1, quantPecas2 : integer;
            vez : boolean;
          end;	

partida : record //Definições da partida
            capturarParaTras, obrigadoCapturar, sonsAtivos : boolean;
          end;

rede : record  //Definições de rede
         ativa, vez, estabelecendoConexao : boolean;
         socket : text;
         caminhoSocket : string;
         nick, nickOponente : string[8];
         mensagem : string[9];
       end;         
		               
 //----------------------------------------------
 //----------------------------------------------
 //----------------------------------------------
 //---FUNÇÕES PARA GERENCIAMENTO GRÁFICO---------
 //----------------------------------------------
 //----------------------------------------------
 //----------------------------------------------

 //---------------------------------------------
 // Desenha um retângulo maciço
 //--------------------------------------------- 
 Procedure DesenhaRetangulo(posCol, posLin,           
                            dimCol, dimLin, 
				        cor, corF : integer ;
					   carac : char);
 Var
 cont : integer; linha : string; 			    
 Begin
   textcolor(cor) ;
   textbackground(corF) ;
   for cont := 1 to dimCol do
	if (cont > 1) then
	linha := concat(linha, carac)
	else
	linha := carac;
   for cont := 1 to dimLin do
   begin
     gotoxy(posCol, posLin + cont - 1) ;
     write(linha);
   end;
 End;
 
 //---------------------------------------------
 // Desenha bordas sombreadas de um retângulo
 //--------------------------------------------- 
 Procedure DesenhaContorno(posCol, posLin, //Posição (Coluna/Linha)            
                           dimCol, dimLin, //Dimensão (Coluna/Linha)
				       corLinha, corFundoLinha : integer; //Cor/Cor de fundo
				       sombreamento : boolean); //Disposição da sombra				    
 Const
 CARAC_CANTO_NE = #191; CARAC_CANTO_NO = #218;	
 CARAC_CANTO_SE = #217; CARAC_CANTO_SO = #192;	
 CARAC_HORIZONT = #196; CARAC_VERTICAL = #179;
 Var
 cont, cor1, cor2 : integer;		    
 Begin 
   cont := 0;
   if (sombreamento) then 
   begin cor1 := corLinha; cor2 := corLinha + 8; end 
   else 
   begin cor2 := corLinha; cor1 := corLinha + 8; end;
   textbackground(corFundoLinha) ;
   while (cont < dimCol - 1) or (cont < dimLin - 1) do
   begin 
     if (cont < dimCol - 1) then
     begin
       textcolor(cor1);
       gotoxy(posCol + cont, posLin); if (cont > 0) then 
	  write(CARAC_HORIZONT) else write(CARAC_CANTO_NO); //LINHA HORIZONTAL NORTE - ARESTA NOROESTE
	  textcolor(cor2);
       gotoxy(posCol + dimCol - cont - 1, posLin + dimLin - 1) ; if (cont > 0) then
	  write(CARAC_HORIZONT) else write(CARAC_CANTO_SE); //LINHA HORIZONTAL NORTE - ARESTA SUDESTE 
     end;
	if (cont < dimLin - 1) then
	begin 
	  textcolor(cor1); 
       gotoxy(posCol, posLin + dimLin - cont - 1); if (cont > 0) then
	  write(CARAC_VERTICAL) else write(CARAC_CANTO_SO); //LINHA VERTICAL OESTE - ARESTA SUDOESTE
	  textcolor(cor2);
       gotoxy(posCol + dimCol - 1, posLin + cont); if (cont > 0) then 
	  write(CARAC_VERTICAL) else write(CARAC_CANTO_NE); //LINHA VERTICAL LESTE - ARESTA NOROESTE
     end;
	inc(cont);
   end;
   textcolor(black);
 End;

 //---------------------------------------------
 // Desenha o tabuleiro
 //--------------------------------------------- 
 Procedure DesenhaTabuleiro(alternarCorCasas : boolean) ;
 Var
 auxA, auxB : integer ;
 alternarCor : boolean ;
 corCasa : integer ;
 Begin
   alternarCor := alternarCorCasas ;
   for auxA := 0 to tabuleiro.quantidadeCasas - 1 do
    begin
      alternarCor := not(alternarCor) ;
      for auxB := 0 to tabuleiro.quantidadeCasas - 1 do
      begin
        if alternarCor then
        begin
          corCasa := tabuleiro.cor1 ;
          alternarCor := not(alternarCor) ;
        end else
        begin
          corCasa := tabuleiro.cor2 ;
          alternarCor := not(alternarCor) ;
        end;
	   DesenhaRetangulo(POS_COL_TABULEIRO + casa.dimCol * auxA,
	                    POS_LIN_TABULEIRO + casa.dimLin * auxB,
					casa.dimCol, casa.dimLin,
					corCasa, COR_FUNDO,
					#219);
      end;
    end;
 End;

 //---------------------------------------------
 // Redefine uma casa
 //---------------------------------------------
 Procedure  ResetCasa(posCol, posLin : integer);
 Var
 cor1, cor2 : integer;
 Begin 
 
   if (tabuleiro.grade[posCol, posLin] >= V_1_D) or 
      (tabuleiro.grade[posCol, posLin] >= V_2_D) then
   begin
     cor1 := jogador.cor1 + 8;
     cor2 := jogador.cor2 + 8;
   end else
   begin
     cor1 := jogador.cor1;  
     cor2 := jogador.cor2;
   end;
     
   DesenhaRetangulo(POS_COL_TABULEIRO + (posCol - 1) * casa.dimCol,
	               POS_LIN_TABULEIRO + (posLin - 1) * casa.dimLin,
			     casa.dimCol, casa.dimLin,
			     tabuleiro.cor1, COR_FUNDO,
			     #219);
   if tabuleiro.grade[posCol, posLin] > 0 then
     if (tabuleiro.grade[posCol, posLin] = V_1) or
	   (tabuleiro.grade[posCol, posLin] = V_1_D) then
     begin
	  DesenhaRetangulo(POS_COL_TABULEIRO + 1 + (posCol- 1) * casa.dimCol,
	                   POS_LIN_TABULEIRO + 1 + (posLin - 1) * casa.dimLin,
				    casa.dimCol - 2, casa.dimLin - 2,
				    cor1, cor1,
				    #219);
     end else
     begin
	  DesenhaRetangulo(POS_COL_TABULEIRO + 1 + (posCol - 1) * casa.dimCol,
	                   POS_LIN_TABULEIRO + 1 + (posLin - 1) * casa.dimLin,
				    casa.dimCol - 2, casa.dimLin - 2,
				    cor2, cor2,
				    #219);
     end;			     
 End;

 //---------------------------------------------
 // Seleciona uma casa
 //--------------------------------------------- 
 Procedure SelecionaCasa(sombreamento : boolean) ;
 Begin
   DesenhaContorno(POS_COL_TABULEIRO + (tabuleiro.posColAtiva - 1) * casa.dimCol, 
   			    POS_LIN_TABULEIRO + (tabuleiro.posLinAtiva - 1) * casa.dimLin,
                   casa.dimCol, casa.dimLin,
			    white, tabuleiro.cor1,
			    sombreamento); 
 End;

 //---------------------------------------------
 // Desenha todas as peças do tabuleiro
 //--------------------------------------------- 
 Procedure DesenhaPecas ;
 Var
 auxA, auxB : integer;
 Begin
   for auxA := 1 to tabuleiro.quantidadeCasas do
    for auxB := 1 to tabuleiro.quantidadeCasas do
    begin
      if (tabuleiro.grade[auxA, auxB] > 0) then
      ResetCasa(auxA, auxB);
    end;
 End;

 //---------------------------------------------
 // Verifica se a referência a uma casa do tabuleiro é válida
 //--------------------------------------------- 
 Function VerificaCasa(posCol, posLin : integer) : boolean ;
 Begin 
   if (posCol > 0) and 
      (posCol <= tabuleiro.quantidadeCasas) and
	 (posLin > 0) and
	 (posLin <= tabuleiro.quantidadeCasas) then
     VerificaCasa := true
   else
     VerificaCasa := false;		 
 End;
 
 //---------------------------------------------
 // Inicia e posiciona as casas no tabuleiro
 //---------------------------------------------
 Procedure IniciaCasas ;
 Var
 auxA, auxB : integer ;
 casaValida : boolean ;
 Begin
   casaValida := false;
   for auxA := 1 to tabuleiro.quantidadeCasas do
    begin     
      for auxB := 1 to tabuleiro.quantidadeCasas do
      begin
        if casaValida then
        begin
          casaValida := not(casaValida) ;
          if (auxB <= tabuleiro.quantidadeCasas div 2 - 1) then
          begin
            tabuleiro.grade[auxA, auxB] := V_2; //Marca a posição na grade (Jogador1)
		end else
	     begin
		  if ((auxB > tabuleiro.quantidadeCasas div 2 + 1)) then
		  begin
		    tabuleiro.grade[auxA, auxB] := V_1; //Marca a posição na grade (Jogador2)
		  end;
		end; 	
        end else
        casaValida := not(casaValida) ;
      end;
      casaValida := not(casaValida) ;
    end;
    DesenhaPecas;  
 End;

 //---------------------------------------------
 // Desenha um painel com um título
 //--------------------------------------------- 
 Procedure DesenhaPainel(posCol, posLin,           
                         dimCol, dimLin : integer; 
				     rotulo : string);
 {DESENHA UM PAINEL SOMBREADO COM UM NOME
  'posCol' e 'posLin' recebem a dimensão do retãngulo
  'dimCol' e 'dimLin' recebem a dimensão do retângulo
  'cor' recebe a cor do retângulo}
 Begin
   DesenhaRetangulo(posCol + 2 , posLin + 1, dimCol, dimLin, 16, 16, #219);               
   DesenhaRetangulo(posCol, posLin, dimCol, dimLin, 7, 7, #219); 
   DesenhaContorno(posCol, posLin, dimCol, dimLin, 16, 7, false);
   DesenhaRetangulo(posCol, posLin, dimCol, 1, 1, 1, #219);
   textcolor(15); textbackground(1);
   gotoxy(posCol + 1, posLin); write(rotulo);
   textcolor(16); textbackground(7);				
 End;
 

 //---------------------------------------------
 // Configura as definições iniciais
 //--------------------------------------------- 
 Procedure Inicializa ;
 Var
 auxA, auxB : integer;
 Begin
   for auxA := 1 to tabuleiro.quantidadeCasas do
     for auxB := 1 to tabuleiro.quantidadeCasas do
     begin
       tabuleiro.grade[auxA, auxB] := 0;
     end;
   jogador.quantPecas1 := 
   (tabuleiro.quantidadeCasas - (tabuleiro.quantidadeCasas div 2)) * ((tabuleiro.quantidadeCasas div 2) - 1);
   jogador.quantPecas2 := jogador.quantPecas1;
   tabuleiro.cor1 := black ; 
   tabuleiro.cor2 := white ;
   tabuleiro.disposicao := true ;
   DesenhaContorno(POS_COL_TABULEIRO - 1,
   			    POS_LIN_TABULEIRO - 1,
                   casa.dimCol * tabuleiro.quantidadeCasas + 2,
			    casa.dimLin * tabuleiro.quantidadeCasas + 2,
			    7,3,true); //Desenha o contorno em torno do tabuleiro
   tabuleiro.posColAtiva := 1;
   tabuleiro.posLinAtiva := 8;
   jogador.cor1 := blue; 
   jogador.cor2 := red;
   DesenhaTabuleiro(tabuleiro.disposicao);
   IniciaCasas;
   DesenhaPainel(20,11,41,11,'Dica');
   SelecionaCasa(false);
   textbackground(7) ;
   gotoxy(22, 13); writeln('Para realizar os movimentos: ');
   gotoxy(22, 15); writeln(' 1 - Tecle ENTER sobre a peça;');
   gotoxy(22, 16); writeln(' 2 - Vá até a casa de destino e pres-');
   gotoxy(22, 17); writeln('   sione ENTER para movê-la.');
   gotoxy(22, 19); writeln('             BOM JOGO :)');
   gotoxy(80,1); readkey;
   DesenhaTabuleiro(tabuleiro.disposicao);
   IniciaCasas;
   partida.obrigadoCapturar := false;
   SelecionaCasa(false);
   gotoxy(80,1); 
 End;

 //----------------------------------------------
 //----------------------------------------------
 //----------------------------------------------
 //-------FUNÇÕES PARA GERENCIAMENTO LÓGICO------
 //----------------------------------------------
 //----------------------------------------------
 //----------------------------------------------
 
 //---------------------------------------------
 // Analisa o conteúdo do segmento de uma diagonal
 //---------------------------------------------  
 Function AnalisaSegmento(posColOrigem, posLinOrigem,
                          posColDestino, posLinDestino : integer) : integer ;
 Var
 incCol, incLin, leitura, posColVerificada, posLinVerificada : integer;
 Begin
   if (tabuleiro.grade[posColDestino, posLinDestino] > 0) then  
   begin  //-1 retorna erro
     AnalisaSegmento := -1;
	Exit; 
   end;
   if (posColDestino > posColOrigem) then
     incCol := 1 
   else 
     incCol := -1;
   if (posLinDestino > posLinOrigem) then
     incLin := 1 
   else 
     incLin := -1; 
   posColVerificada := posColOrigem;
   posLinVerificada := posLinOrigem;
   repeat
     posColVerificada := posColVerificada + incCol;
     posLinVerificada := posLinVerificada + incLin;
     leitura := leitura + tabuleiro.grade[posColVerificada, posLinVerificada];
   until (posColVerificada = posColDestino) and
         (posLinVerificada = posLinDestino);
   AnalisaSegmento := leitura;      
 End;

 //---------------------------------------------
 // Verifica se há possibilidade de captura por peça
 //--------------------------------------------- 
 Function VerificaPossibilidadeCaptura (posCol, posLin : integer) : boolean ;
 Var
 posColVerificada, posLinVerificada, valorPeca, valorSegmento : integer;
   
   //Subfunção de VerificaPossibilidadeCaptura()
   Function ProcessaValorSegmento : boolean;
   Begin
     if (((valorSegmento = V_1) or (valorSegmento = V_1_D)) and
        ((valorPeca = V_2) or (valorPeca = V_2_D))) or
	   (((valorSegmento = V_2) or (valorSegmento = V_2_D)) and
        ((valorPeca = V_1) or (valorPeca = V_1_D))) then
     ProcessaValorSegmento := true 
	else
	ProcessaValorSegmento := false;	  
   End;
 
 Begin
   valorPeca := tabuleiro.grade[posCol, posLin];
   posColVerificada := posCol + 1;
   posLinVerificada := posLin - 1; 
   repeat //Analisa a NE
     inc(posColVerificada);
     dec(posLinVerificada);
     if not(VerificaCasa(posColVerificada, posLinVerificada)) then
     break;
     if (valorPeca = V_2) and not(partida.capturarParaTras) then
     break;
     if (tabuleiro.grade[posColVerificada, posLinVerificada] = 0) then //Verifica se a posição candidata é vaga
     begin
       valorSegmento := AnalisaSegmento(posCol, posLin, posColVerificada, posLinVerificada);
       if (ProcessaValorSegmento) then
       begin 
         VerificaPossibilidadeCaptura := true;
         Exit;
       end; 
     end;
     if (valorPeca = V_1) or (valorPeca = V_2) then
     break;
   until (posColVerificada = tabuleiro.quantidadeCasas) and
         (posLinVerificada = 1);
   
   posColVerificada := posCol - 1;
   posLinVerificada := posLin - 1;      
   repeat //Analisa a NO
     dec(posColVerificada);
     dec(posLinVerificada);
     if not(VerificaCasa(posColVerificada, posLinVerificada)) then
     break;
     if (valorPeca = V_2) and not(partida.capturarParaTras) then
     break;
     if (tabuleiro.grade[posColVerificada, posLinVerificada] = 0) then //Verifica se a posição candidata é vaga
     begin
       valorSegmento := AnalisaSegmento(posCol, posLin, posColVerificada, posLinVerificada);
       if (ProcessaValorSegmento) then
       begin
         VerificaPossibilidadeCaptura := true;
         Exit;
       end;
     end;
     if (valorPeca = V_1) or (valorPeca = V_2) then
     break;
   until (posColVerificada = 1) and
         (posLinVerificada = 1); 
   
   posColVerificada := posCol + 1;
   posLinVerificada := posLin + 1;	     
   repeat //Analisa a SE
     inc(posColVerificada);
     inc(posLinVerificada);
     if not(VerificaCasa(posColVerificada, posLinVerificada)) then
     break;
     if (valorPeca = V_1) and not(partida.capturarParaTras) then
     break;
     if (tabuleiro.grade[posColVerificada, posLinVerificada] = 0) then //Verifica se a posição candidata é vaga
     begin
       valorSegmento := AnalisaSegmento(posCol, posLin, posColVerificada, posLinVerificada);
       if (ProcessaValorSegmento) then
       begin
         VerificaPossibilidadeCaptura := true;
         Exit;
       end;
     end;
     if (valorPeca = V_1) or (valorPeca = V_2) then
     break;
   until (posColVerificada = tabuleiro.quantidadeCasas) and
         (posLinVerificada = tabuleiro.quantidadeCasas);
         
   posColVerificada := posCol - 1;
   posLinVerificada := posLin + 1;
   repeat //Analisa a SO
     dec(posColVerificada);
     inc(posLinVerificada);
     if not(VerificaCasa(posColVerificada, posLinVerificada)) then
     break;
     if (valorPeca = V_1) and not(partida.capturarParaTras) then
     break;
     if (tabuleiro.grade[posColVerificada, posLinVerificada] = 0) then //Verifica se a posição candidata é vaga
     begin
       valorSegmento := AnalisaSegmento(posCol, posLin, posColVerificada, posLinVerificada);
       if (ProcessaValorSegmento) then
       begin
         VerificaPossibilidadeCaptura := true;
         Exit;
       end;
     end;
     if (valorPeca = V_1) or (valorPeca = V_2) then
     break;
   until (posColVerificada = 1) and
         (posLinVerificada = tabuleiro.quantidadeCasas);
         
   VerificaPossibilidadeCaptura := false;	          
 End;

 //---------------------------------------------
 // Verifica se há possibilidade de captura em todo o tabuleiro
 //---------------------------------------------
 Function VerificaChanceCaptura : boolean ;
 Var
 auxA, auxB : integer ;
 Begin
   for auxA := 1 to tabuleiro.quantidadeCasas do
   begin
     for auxB := 1 to tabuleiro.quantidadeCasas do
     begin
       if (jogador.vez) then
       begin
         if (tabuleiro.grade[auxA, auxB] = V_1) or
	       (tabuleiro.grade[auxA, auxB] = V_1_D) then
         if (VerificaPossibilidadeCaptura(auxA, auxB)) then
         begin
           VerificaChanceCaptura := true;
           Exit;
         end;
       end else
       begin
         if (tabuleiro.grade[auxA, auxB] = V_2) or
	       (tabuleiro.grade[auxA, auxB] = V_2_D) then
         if (VerificaPossibilidadeCaptura(auxA, auxB)) then
         begin
           VerificaChanceCaptura := true;
           Exit;
         end;
       end;
     end;
   end;
   VerificaChanceCaptura := false;
 End;

 //---------------------------------------------
 // Remove peça do segmento de uma diagonal
 //--------------------------------------------- 
 Procedure RemovePeca (posColOrigem, posLinOrigem,
                       posColDestino, posLinDestino : integer);
 Var
 incCol, incLin, posColVerificada, posLinVerificada: integer;                      
 Begin
   if (posColDestino > posColOrigem) then
     incCol := 1 
   else 
     incCol := -1;
   if (posLinDestino > posLinOrigem) then
     incLin := 1 
   else 
     incLin := -1; 
   posColVerificada := posColOrigem;
   posLinVerificada := posLinOrigem;
   repeat
     posColVerificada := posColVerificada + incCol;
     posLinVerificada := posLinVerificada + incLin;
     tabuleiro.grade[posColVerificada, posLinVerificada] := 0;
     ResetCasa(posColVerificada, posLinVerificada);
   until (posColVerificada = posColDestino) and
         (posLinVerificada = posLinDestino);    
 End;

 //---------------------------------------------
 // Gerencia o movimento das peças
 //--------------------------------------------- 
 Function MovePeca(posCol, posLin : integer) : boolean;
 Var
 dama, possibilidadeCaptura, captura : boolean;
 distancia, valorSegmento : integer;
 direcao : string; {direcao: NE - NO - SE - SO}
 Begin
   //Verifica Diagonal  
   
   if not((tabuleiro.origemCol + posLin) = (tabuleiro.origemLin + posCol)) and
      not((tabuleiro.origemCol + tabuleiro.origemLin) = (posCol + posLin)) then
   begin
     MovePeca := false; 
     tabuleiro.erro := true;
     Exit; //Sai da função
   end;   
 
   //Verifica se a posição está livre
   if not(tabuleiro.grade[posCol, posLin] = 0) then
   begin
     MovePeca := false; //Sai da função
     tabuleiro.erro := true;
     Exit;
   end;
 
   //Verifica se a peça de origem é dama ou peão
   if (tabuleiro.grade[tabuleiro.origemCol, tabuleiro.origemLin] = V_1_D) or 
      (tabuleiro.grade[tabuleiro.origemCol, tabuleiro.origemLin] = V_2_D) then
   dama := true //Identifica peça de origem como dama
   else
   dama := false; //Identifica peça de origem como peão
   
   //Registra Distância
   distancia := tabuleiro.origemLin - posLin;
   distancia := abs(distancia);
 
   //Registra Direção
   if (tabuleiro.origemCol > posCol) then
   begin
     if(tabuleiro.origemLin > posLin) then
       direcao := 'NO'
     else
       direcao := 'SO';
   end else
   begin
     if(tabuleiro.origemLin > posLin) then
       direcao := 'NE'
     else
       direcao := 'SE';
   end;	
   
   //VerificaSegmento 
   valorSegmento := AnalisaSegmento(tabuleiro.origemCol, tabuleiro.origemLin,
                                    posCol, posLin);
   if (valorSegmento = -1) then
   begin
     MovePeca := false; //Sai da função
     tabuleiro.erro := true; 
     Exit;                              
   end;                                 
   
   //Verifica Possibilidade Captura no tabuleiro
   possibilidadeCaptura := VerificaChanceCaptura;
                                    
   //Move a peça
   if (jogador.vez) then
   begin
	if (not(dama) and
	   (((distancia = 1) and ((direcao = 'NO') or (direcao = 'NE'))) or
	   ((distancia = 2) and (((valorSegmento = V_2) or (valorSegmento = V_2_D))) and (((direcao = 'NO') or (direcao = 'NE')))) or                                   
	   ((distancia = 2) and (((valorSegmento = V_2) or (valorSegmento = V_2_D))) and  (((direcao = 'SO') or (direcao = 'SE'))) and 
	   partida.capturarParaTras))) or 
	   (dama and ((valorSegmento = 0) or (valorSegmento = V_2) or (valorSegmento = V_2_D))) then 	       
     begin  
       if (valorSegmento > 0) then
         captura := true //Houve captura
       else  
       begin
         captura := false;
         if (possibilidadeCaptura) and not(captura) then  //Se há possibilidade de captura, mas não houve captura, não interrompa
         begin
           DesenhaPainel(19,11,41,8,'Aviso');
           if (partida.sonsAtivos) then write(#7);
           gotoxy(26, 13); writeln('Voc', #136, ' deve comer a peça!'); gotoxy(80, 1);
           readkey;
           DesenhaRetangulo(1,1,80,43,3,7,#219);//Pinta o fundo
           DesenhaTabuleiro(tabuleiro.disposicao);
           DesenhaPecas;
           tabuleiro.erro := true;
           MovePeca := false;
	      Exit;
         end; 
       end;
	  RemovePeca(tabuleiro.origemCol, tabuleiro.origemLin, posCol, posLin);
	  tabuleiro.grade[posCol, posLin] := tabuleiro.grade[tabuleiro.origemCol, tabuleiro.origemLin] ;
	  tabuleiro.grade[tabuleiro.origemCol, tabuleiro.origemLin] := 0;
	  ResetCasa(tabuleiro.origemCol, tabuleiro.origemLin);
       ResetCasa(posCol, posLin);  
       if (captura) then //Se houver captura
	  begin
	    dec(jogador.quantPecas2); //Desconta uma peça do adversário 
	    if VerificaPossibilidadeCaptura(posCol, posLin) then
	    begin //Não passa a vez se houver de capturar mais peças
	      tabuleiro.oCol := tabuleiro.origemCol;
	      tabuleiro.oLin := tabuleiro.origemLin;
	      tabuleiro.origemCol := posCol;
	      tabuleiro.origemLin := posLin;
	      partida.obrigadoCapturar := true;
	      tabuleiro.erro := false;
	      MovePeca := false;
	      Exit;
	    end;  
       end;
       if ((posLin = 1) and 
	     (tabuleiro.grade[posCol, posLin] = V_1)) then
	  begin //Define dama
	    tabuleiro.grade[posCol, posLin] := V_1_D;
	    ResetCasa(posCol, posLin);
	  end;
	  tabuleiro.erro := false; 
	  MovePeca := true;
	  Exit;
	end;    
   end else
   begin
     if (not(dama) and
	   (((distancia = 1) and ((direcao = 'SO') or (direcao = 'SE'))) or
	   ((distancia = 2) and (((valorSegmento = V_1) or (valorSegmento = V_1_D))) and (((direcao = 'SO') or (direcao = 'SE')))) or
	   ((distancia = 2) and (((valorSegmento = V_1) or (valorSegmento = V_1_D))) and (((direcao = 'NO') or (direcao = 'NE'))) and
	   partida.capturarParaTras))) or 
	   (dama and ((valorSegmento = 0) or (valorSegmento = V_1) or (valorSegmento = V_1_D))) then
     begin
       if (valorSegmento > 0) then
         captura := true //Houve captura
       else  
       begin
         captura := false;
         if (possibilidadeCaptura) and not(captura) then //Se há possibilidade de captura, mas não houve captura, não interrompa
         begin
           DesenhaPainel(19,11,41,8,'Aviso');
           if (partida.sonsAtivos) then write(#7);
           gotoxy(26, 13); writeln('Voc', #136, ' deve comer a peça!'); gotoxy(80, 1);
           readkey;
           DesenhaRetangulo(1,1,80,43,3,7,#219);//Pinta o fundo
           DesenhaTabuleiro(tabuleiro.disposicao);
           DesenhaPecas;
           tabuleiro.erro := true;
           MovePeca := false;
	      Exit;
         end; 
       end;
	  RemovePeca(tabuleiro.origemCol, tabuleiro.origemLin, posCol, posLin);
	  tabuleiro.grade[posCol, posLin] := tabuleiro.grade[tabuleiro.origemCol, tabuleiro.origemLin] ;
	  tabuleiro.grade[tabuleiro.origemCol, tabuleiro.origemLin] := 0;
	  ResetCasa(tabuleiro.origemCol, tabuleiro.origemLin);
       ResetCasa(posCol, posLin);
       if (captura) then //Se houver captura
	  begin
	    dec(jogador.quantPecas1); //Desconta uma peça do adversário 
	    if VerificaPossibilidadeCaptura(posCol, posLin) then
	    begin //Não passa a vez se houver de capturar mais peças
	      tabuleiro.oCol := tabuleiro.origemCol;
	      tabuleiro.oLin := tabuleiro.origemLin;
	      tabuleiro.origemCol := posCol;
	      tabuleiro.origemLin := posLin;
	      partida.obrigadoCapturar := true;
	      tabuleiro.erro := false;
	      MovePeca := false;
	      Exit;
	    end;  
       end;
	  if ((posLin = tabuleiro.quantidadeCasas) and 
	     (tabuleiro.grade[posCol, posLin] = V_2)) then
	  begin  //Define dama
	    tabuleiro.grade[posCol, posLin] := V_2_D;
	    ResetCasa(posCol, posLin);
	  end; 
	  MovePeca := true;
	  tabuleiro.erro := false;
	  Exit;
	end;
   end;
   tabuleiro.erro := true;
   MovePeca := false;      
 End;

 //----------------------------------------------
 //----------------------------------------------
 //----------------------------------------------
 //---GERENCIAMENTO DAS PARTIDAS EM REDE---------
 //----------------------------------------------
 //----------------------------------------------
 //----------------------------------------------

 {1 - As modificações exercidas sobre o arquivo de socket
  serão monitoradas pela função PercebeAtividadeSocket. Se a função
  perceber alguma mudança no arquivo, retornará true.
  2 - Os dados serão lidos. Se for indicado que o oponente
  já passou a vez, a jogada será realizada e os dados enviados para
  que o tabuleiro interrompa. Se for indicado que o oponente transmitiu, os dados 
  serão lidos e sobrescritos com um 'ok'
  para indicar ao oponente que ele pode prosseguir transmitindo. 
  3 - A mensagem terá o modelo ABBCCDDEE:
  A - flag que receberá 1 para passou a vez ou 0 para não passou a vez
  BB- Posição da coluna da origem da peça
  CC- Posição da linha da origem da peça 
  DD- Posição da coluna da destino da peça 
  EE- Posição da linha do destino da peça
  4 - A partida iniciará com o criador do arquivo escrevendo o seu
  nick no arquivo. O oponente lerá e sobrescreverá com seu nick.
  O criador do arquivo sobrescreverá o arquivo com um 'ok' para iniciar o jogo.
  O criador do arquivo e o oponente iniciarão o jogo, onde a primeira
  jogada é do criador do arquivo.   
 }
 
 //---------------------------------------------
 // Retorna true se for percebido alguma mudança no arquivo
 //---------------------------------------------
 Function PercebeAtividadeSocket : boolean;
 Var
 mensagem : string[9];
 Begin 
   reset(rede.socket);
   readln(rede.socket, mensagem); //Obtém mensagem
   close(rede.socket);
   if (mensagem <> rede.mensagem) then
   PercebeAtividadeSocket := true
   else
   PercebeAtividadeSocket := false;
 End;

 //---------------------------------------------
 // Recebe a mensagem na rede e aplica as mudanças
 //---------------------------------------------
 Function RecebeMensagem : boolean;
 Var
 flag, posColD, posLinD, posColO, posLinO, cErro, peca : integer;
 mensagem : string;
 a : text;
 Begin
   if (partida.sonsAtivos) then write(#7);
   reset(rede.socket);
   readln(rede.socket, mensagem); //Obtém mensagem
   close(rede.socket);

   if (mensagem = 'socketLi') then
   begin           
     rede.mensagem := 'socketLi';
     RecebeMensagem := true;
     Exit;
   end;

   if (length(mensagem) <> 9) then //Verifica se a mensagem está integral
   begin
     RecebeMensagem := false;
     Exit;
   end;

   val(copy(mensagem, 1, 1), flag, cErro); //Isola flag
   val(copy(mensagem, 2, 2), posColO, cErro); //Isola posColOrigem
   val(copy(mensagem, 4, 2), posLinO, cErro); //Isola posLinOrigem
   val(copy(mensagem, 6, 2), posColD, cErro); //Isola posColDestino
   val(copy(mensagem, 8, 2), posLinD, cErro); //Isola posLinDestino 
   tabuleiro.origemCol := posColO;
   tabuleiro.origemLin := posLinO;
  
   if (MovePeca(posColD, posLinD)) then begin end;
   if (flag = 1) then jogador.vez := true else jogador.vez := false; 
   rewrite(rede.socket);
   writeln(rede.socket, 'ok');
   close(rede.socket);
   rede.mensagem := 'ok';
   if (partida.obrigadoCapturar) then partida.obrigadoCapturar := false; 
   RecebeMensagem := true; 
 End; 

 //---------------------------------------------
 // Envia a mensagem na rede
 //---------------------------------------------
 Procedure EnviaMensagem ;
 Var
 flag, posColO, posLinO, posColD, posLinD, mensagem : string;
 Begin
  
   gotoxy(30, (tabuleiro.quantidadeCasas * casa.dimLin) + 3);
   textcolor(white); textbackground(3);
   write('  Transmitindo...   '); gotoxy(80, 1);
  
   reset(rede.socket);
   readln(rede.socket, mensagem); //Obtém a ultima mensagem do socket
   close(rede.socket);
   if (mensagem = 'socketLi') then //Verifica se jogador desistiu
   begin
     gotoxy(30, (tabuleiro.quantidadeCasas * casa.dimLin) + 3);
     write('                    '); gotoxy(80, 1);
     rede.mensagem := 'socketLi';
     Exit;
   end;
   
   if (partida.obrigadoCapturar) then
   begin
     jogador.vez := true;
     flag := '0';
     str((tabuleiro.quantidadeCasas - tabuleiro.oCol + 1), posColO); //Inverte posição
     if (length(posColO) = 1) then posColO := concat('0', posColO);   
     str((tabuleiro.quantidadeCasas - tabuleiro.oLin + 1), posLinO); //Inverte posição
     if (length(posLinO) = 1) then posLinO := concat('0', posLinO);
   end else
   begin
     jogador.vez := false;
     flag := '1';
     str((tabuleiro.quantidadeCasas - tabuleiro.origemCol + 1), posColO); //Inverte posição
     if (length(posColO) = 1) then posColO := concat('0', posColO);   
     str((tabuleiro.quantidadeCasas - tabuleiro.origemLin + 1), posLinO); //Inverte posição
     if (length(posLinO) = 1) then posLinO := concat('0', posLinO);
   end;
   
   str((tabuleiro.quantidadeCasas - tabuleiro.posColAtiva + 1), posColD); //Inverte posição
   if (length(posColD) = 1) then posColD := concat('0', posColD);
   str((tabuleiro.quantidadeCasas - tabuleiro.posLinAtiva + 1), posLinD); //Inverte posição 
   if (length(posLinD) = 1) then posLinD := concat('0', posLinD); 
   mensagem := concat(flag, posColO, posLinO, posColD, posLinD);
   rewrite(rede.socket);
   writeln(rede.socket, mensagem);
   close(rede.socket);
   rede.mensagem := mensagem;
   while (true) do
   begin
     delay(10);
     if (PercebeAtividadeSocket) then
     begin
       rede.mensagem := 'ok';
       break;
     end;
   end;
 End;

 //---------------------------------------------
 // Cria uma partida em rede
 //---------------------------------------------   
 Procedure CriaPartida ;
 Begin
   DesenhaPainel(25,15,35,9,'Aviso!');
   gotoxy(27, 18); write('Partida criada!');
   jogador.vez := true;
   rede.vez := true;
   rede.ativa := true; 
   gotoxy(80, 1); delay(2000);
   rede.mensagem := rede.nick;
   close(rede.socket);
   rewrite(rede.socket);
   writeln(rede.socket, rede.nick);
   writeln(rede.socket, tabuleiro.quantidadeCasas); //Informa no socket a dimensão do tabuleiro
   if (partida.capturarParaTras) then
   writeln(rede.socket, 'true') //Informa no socket a possibilidade de capturar para trás
   else
   writeln(rede.socket, 'false');
   close(rede.socket);
   DesenhaRetangulo(27, 18, 20, 1, 7, 7, #219); textcolor(black) ;
   gotoxy(27, 18); write('Aguardando oponente'); gotoxy(80, 1);
   while (true) do begin
     if(PercebeAtividadeSocket) then
     begin
       reset(rede.socket);
	  readln(rede.socket, rede.nickOponente); //Obtém nick do agregado à partida
	  close(rede.socket);
       rewrite(rede.socket);
       writeln(rede.socket, 'ok'); //Responde ao agregado à partida que a partida pode iniciar
       close(rede.socket);
       DesenhaRetangulo(27, 18, 20, 1, 7, 7, #219); textcolor(black) ;
       gotoxy(27, 18); write(rede.nickOponente, ' está se conectando'); gotoxy(80, 1);
       delay(2000);
       break;
     end;
     delay(10);
   end;
 End;
 
 //----------------------------------------------
 //----------------------------------------------
 //----------------------------------------------
 //---FUNÇÕES PARA O GERENCIAMENTO DE MENUS------
 //----------------------------------------------
 //----------------------------------------------
 //----------------------------------------------
 
 Function GerenciaMenu (menu : integer) : integer;
 var
 opcao : char;
  
  Procedure MenuSobre ;
  Begin
    DesenhaPainel(23,13,41,12,'Sobre');
    gotoxy(25, 15); writeln('         Damas - vers', #198, 'o 1.0');
    gotoxy(25, 17); writeln('Desenvolvido por Guilherme Resende S', #160);
    gotoxy(25, 18); writeln('    contato: gresendesa@gmail.com');   
    gotoxy(25, 20); writeln('     Programa escrito em pascal');
    gotoxy(25, 22); writeln('                2012');
    gotoxy(80, 1);
    readkey;
    DesenhaRetangulo(1,1,80,43,3,7,#219);//Pinta o fundo 
  End;

 //---------------------------------------------
 // SubFunção de GerenciaMenu - Gerencia o menu do tabuleiro
 //---------------------------------------------    
  Procedure MenuTabuleiro ;
  var
  opcaoMenuTabuleiro : char;
  Begin
    DesenhaPainel(25,15,35,9,'Tabuleiro');
    gotoxy(27, 17); writeln('1 - 8x8 Damas brasileiras');
    gotoxy(27, 19); writeln('2 - 10x10 Damas internacionais');
    gotoxy(27, 21); writeln('3 - 12x12 Damas canadianas');
    gotoxy(80, 1); 
    repeat 
	 opcaoMenuTabuleiro := readkey;
    until (opcaoMenuTabuleiro = '1') or (opcaoMenuTabuleiro = '2') or
          (opcaoMenuTabuleiro = '3') or (opcaoMenuTabuleiro = #27);
    case (opcaoMenuTabuleiro) of
      '1': begin
            tabuleiro.quantidadeCasas := 8;
      	  casa.dimCol := 6 ;
            casa.dimLin := 5 ;
	      end;
      '2': begin
             tabuleiro.quantidadeCasas := 10;
             casa.dimCol := 5 ;
             casa.dimLin := 4 ;
	      end;
	 '3': begin
	        tabuleiro.quantidadeCasas := 12;
	        casa.dimCol := 4 ;
             casa.dimLin := 3 ;
	      end;     
      else ;
    end;      
  End;

 //---------------------------------------------
 // SubFunção de GerenciaMenu - Gerencia o menu das configurações
 //---------------------------------------------    
  Procedure MenuConfiguracoes ;
  Var
  opcaoMenuConfiguracoes : char;
  Begin
    repeat
      DesenhaPainel(23,13,41,12, 'Configurações'); 
	 gotoxy(25, 15); writeln('1 - Tabuleiro');
      gotoxy(25, 17); write('2 - Capturar para tr', #160, 's '); 
	 if partida.capturarParaTras then
	 write('ATIVADO   ')
	 else
	 write('DESATIVADO');
	 gotoxy(25, 19); write('3 - Alertas sonoros ');
	 if (partida.sonsAtivos) then
	 write('ATIVADOS   ')
	 else
	 write('DESATIVADOS');
      gotoxy(25, 21); writeln('4 - Voltar');
      gotoxy(80, 1);
	 opcaoMenuConfiguracoes := readkey;
	 case (opcaoMenuConfiguracoes) of
        '1': MenuTabuleiro ;
        '2': partida.capturarParaTras := not(partida.capturarParaTras) ;
        '3': partida.sonsAtivos := not(partida.sonsAtivos) ;
        '4': Exit ;
        else ;
      end;
    until (opcaoMenuConfiguracoes= '4') or
          (opcaoMenuConfiguracoes = #27);
    DesenhaRetangulo(1,1,80,43,3,7,#219);//Pinta o fundo 
  End;
 
 //---------------------------------------------
 // SubFunção de GerenciaMenu - Gerencia o menu da rede
 //---------------------------------------------  
  Function MenuRede : boolean;
  Var
  opcaoMenuRede : char;
  dimensaoTabuleiro, capturarParaTras : string;
  codErro : integer;
  conexaoEstabelecida : boolean;
  Begin
    repeat
      DesenhaPainel(23,13,45,12,'Damas em rede');
      DesenhaContorno(25, 16, 30, 3, black, 7, true);
      gotoxy(25, 15); writeln('1 - Definir nick');
      DesenhaRetangulo(26, 17, 28, 1, black, black, #219);
      textcolor(white); textbackground(black);
      gotoxy(26, 17); writeln(rede.nick);
      DesenhaContorno(25, 21, 41, 3, black, 7, true);
      gotoxy(25, 20); writeln('2 - Caminho do socket *');
      DesenhaRetangulo(26, 22, 39, 1, black, black, #219);
      gotoxy(80, 1); textcolor(white); textbackground(black);
      opcaoMenuRede := readkey;
      case (opcaoMenuRede) of 
        '1': begin
               DesenhaRetangulo(26, 17, 28, 1, black, black, #219);
               gotoxy(26, 17); read(rede.nick);
	        end ;
        '2': begin
               gotoxy(26, 22); read(rede.caminhoSocket);
               assign(rede.socket, rede.caminhoSocket);
               reset(rede.socket); //tenta abrir o arquivo para leitura
               if (ioresult = 0) then
               begin
                 close(rede.socket);
                 reset(rede.socket);
                 readln(rede.socket, rede.nickOponente); //Obtém nick do criador da partida
                 if rede.nickOponente = 'ok' then 
			  begin 
			    DesenhaPainel(25,15,35,9,'Erro!'); 
			    gotoxy(27, 17); write('Socket em uso!');
			    gotoxy(80, 1); delay(2000);
			    Exit;
			  end else
			  begin
			    if rede.nickOponente = 'socketLi' then
			    begin
			      CriaPartida;
			      conexaoEstabelecida := true;
			    end;
			  end; 
			  if not(conexaoEstabelecida) then
			  begin
			    DesenhaPainel(25,15,35,9,'Aviso!');
                   gotoxy(27, 17); write('Conectando-se'); 
                   jogador.vez := false;
                   rede.vez := false;
                   rede.ativa := true;                 
                   gotoxy(80, 1); delay(1000);
                   readln(rede.socket, dimensaoTabuleiro); //Obtém a dimensão do tabuleiro
                   readln(rede.socket, capturarParaTras); //Verifica se na partida é permitido capturar para trás
                   close(rede.socket);
                   val(dimensaoTabuleiro, tabuleiro.quantidadeCasas, codErro);
                   case (tabuleiro.quantidadeCasas) of 
                     8: begin  casa.dimCol := 6 ; casa.dimLin := 5 ; end;
                    10: begin  casa.dimCol := 5 ; casa.dimLin := 4 ; end;
                    12: begin  casa.dimCol := 4 ; casa.dimLin := 3 ; end;
                   end;
			    if (capturarParaTras = 'false') then
                   partida.capturarParaTras := false;
                   DesenhaRetangulo(27, 17, 22, 1, 7, 7, #219); textcolor(black) ;
                   gotoxy(27, 17); write('Aguardando ', rede.nickOponente);
                   gotoxy(80, 1); delay(1000);
                   if (rede.nickOponente = rede.nick) then rede.nick:= concat('+',rede.nick);
                   rede.mensagem := rede.nick; 
			    rewrite(rede.socket); 
                   writeln(rede.socket, rede.nick); //Informa o nick no socket
                   close(rede.socket);
                   while (true) do begin
                     if(PercebeAtividadeSocket) then
                     begin
                       repeat
                         reset(rede.socket); 
                         readln(rede.socket, rede.mensagem); //Aguarda o retorno do criador da partida
                         close(rede.socket);
                       until(length(rede.mensagem) > 0);
                       rede.mensagem := 'ok';
                       break;
                     end;  
                    delay(10);
                   end;
                   conexaoEstabelecida := true;
                 end;  
               end else
               begin
                 rewrite(rede.socket) ; //tenta criar o arquivo
                 DesenhaPainel(25,15,36,9,'Aviso!');
                 if (ioresult <> 0) then
                 begin
                   DesenhaPainel(25,15,41,9,'Erro!');
                   gotoxy(27, 18); write('Não foi possível estabelecer a conexão');
                   rede.ativa := false; 
                   gotoxy(80, 1); delay(3000);
                   conexaoEstabelecida := false;
			  end else
			  begin
		         CriaPartida;
                   conexaoEstabelecida := true;
			  end; 
	          end;
		   end ;
      end;
      MenuRede := false;
      if (conexaoEstabelecida) then
      begin
        MenuRede := true;
        DesenhaRetangulo(1,1,80,43,3,7,#219);//Pinta o fundo
        DesenhaPainel(20,10,38,13,'Partida em rede');
        gotoxy(23, 12); writeln(rede.nick, ' x ', rede.nickOponente);
        gotoxy(23, 14);
	   case (tabuleiro.quantidadeCasas) of 
      	8:  writeln('Damas brasileiras - 8x8');
         10:  writeln('Damas internacionais - 10x10');
         12:  writeln('Damas canadianas - 12x12');
    	   end;
    	   gotoxy(23, 16);
    	   if partida.capturarParaTras then
    	   writeln('PERMITIDO capturar para trás')
    	   else
        writeln('PROIBIDO capturar para trás');
        gotoxy(80,1);
        delay(4000);
      end;
    until (opcaoMenuRede = '2') or (opcaoMenuRede = #27);   
  End;
 
 Begin 
   case (menu) of 
     1: begin //Menu Inicial
	     repeat
	       rede.ativa := false;
		  DesenhaRetangulo(1,1,80,43,3,7,#219);//Pinta o fundo 
		  DesenhaPainel(20,10,38,13,'Damas');
	       gotoxy(23, 12); writeln('1 - Iniciar duelo');
	       gotoxy(23, 14); writeln('2 - Iniciar duelo em rede');
	       gotoxy(23, 16); writeln('3 - Alterar configuraç', #228, 'es');
	       gotoxy(23, 18); writeln('4 - Sobre');
	       gotoxy(23, 20); writeln('5 - Sair do jogo');
	       gotoxy(80, 1);
	       textbackground(3) ;
	       repeat   
	         opcao := readkey;
	       until (opcao = '1') or (opcao = '2') or
		        (opcao = '3') or (opcao = '4') or 
			   (opcao = '5') or (opcao = #27);
		  case (opcao) of 
    		    '1': Inicializa; //iniciar duelo
    		    '2': begin
			      if MenuRede then 
				 begin 
				   Inicializa;
				   GerenciaMenu := 1;
				   Exit;
				 end;
			    end;
    		    '3': MenuConfiguracoes ;
    		    '4': MenuSobre;
    		    '5': begin
                     GerenciaMenu := 0;
                     Exit;
                   end;
		    #27: begin
                     GerenciaMenu := 0;
                     Exit;
                   end;
  		  end;
	     until(opcao <> '2') and (opcao <> '3') and (opcao <> '4');	        
	   end;
     2: begin //Menu do Jogo
	     DesenhaPainel(22,12,38,11,'Menu');
	     repeat
	       gotoxy(25, 14); writeln('1 - Continuar');
	       gotoxy(25, 16); writeln('2 - Desistir :(');
	       gotoxy(25, 18); write('3 - Alertas sonoros ');
	       if (partida.sonsAtivos) then
	       write('ATIVADOS   ')
	       else
	       write('DESATIVADOS');
	       gotoxy(25, 20); writeln('4 - Sair do jogo');
	       gotoxy(80, 1);
	       opcao := readkey;
	       if (opcao = '3') then partida.sonsAtivos := not(partida.sonsAtivos);
	     until (opcao = '1') or (opcao = '2') or
		      (opcao = '4') or (opcao = #27);
	     case (opcao) of 
    		  '1':  ; //continuar
    		  '2': begin
			    if (rede.ativa) then
    		         begin
    		           rewrite(rede.socket); 
                     writeln(rede.socket, 'socketLi'); //Libera o socket
                     close(rede.socket); 
    		         end; 
			    GerenciaMenu := 2;
			    Exit;
		       end;
    		  '4': begin
    		         if (rede.ativa) then
    		         begin
    		           rewrite(rede.socket); 
                     writeln(rede.socket, 'socketLi'); //Libera o socket
                     close(rede.socket); 
    		         end;
                   GerenciaMenu := 0;
			    Exit;
                 end;     
  	     end;
  	     DesenhaRetangulo(1,1,80,43,3,7,#219);//Pinta o fundo
  	     DesenhaPainel(20,10,38,13,'Damas');
		DesenhaTabuleiro(tabuleiro.disposicao);
		DesenhaPecas;   
	   end; 
     else ;
   end; 
   GerenciaMenu := 1;
 End;

 //---------------------------------------------
 // INICIO DO PROGRAMA
 //--------------------------------------------- 
 Begin
   rede.nick := 'Jogador';
   partida.capturarParaTras := true;
   partida.sonsAtivos := false;
   tabuleiro.quantidadeCasas := 8;
   casa.dimCol := 6 ;
   casa.dimLin := 5 ;
   jogador.vez := true;
   if (GerenciaMenu(1) = 0) then
   Exit;
   while (true) do
   begin
     gotoxy(80, 1);
     if (rede.ativa) and not(jogador.vez) then 
	  if PercebeAtividadeSocket then 
	  begin
	    repeat
	      delay(10);
	    until(RecebeMensagem);   
	  end;
     if (keypressed) then   
     begin           
  	  case upcase(readkey) of
         #0: case (readkey) of
               #75: begin           // seta para esquerda
				  if VerificaCasa(tabuleiro.posColAtiva - 2, tabuleiro.posLinAtiva) then
				  begin 
				    ResetCasa(tabuleiro.posColAtiva, tabuleiro.posLinAtiva);
				    tabuleiro.posColAtiva := tabuleiro.posColAtiva - 2 ;				    
                      end; 
				end;
               #77: begin           // seta para direita
                      if VerificaCasa(tabuleiro.posColAtiva + 2, tabuleiro.posLinAtiva) then
                      begin
		  		    ResetCasa(tabuleiro.posColAtiva, tabuleiro.posLinAtiva); 
				    tabuleiro.posColAtiva := tabuleiro.posColAtiva + 2 ;
				  end;
                    end;
               #80: begin           // seta para baixo
		            if VerificaCasa(tabuleiro.posColAtiva, tabuleiro.posLinAtiva + 1) then
		            begin
		              ResetCasa(tabuleiro.posColAtiva, tabuleiro.posLinAtiva);
		              tabuleiro.posLinAtiva := tabuleiro.posLinAtiva + 1 ;
		              if (tabuleiro.posColAtiva < tabuleiro.quantidadeCasas div 2) then
		              inc(tabuleiro.posColAtiva) else dec(tabuleiro.posColAtiva);
		            end;
  
			     end;            
               #72: begin           // seta para cima
		            if VerificaCasa(tabuleiro.posColAtiva, tabuleiro.posLinAtiva - 1) then
		            begin
		              ResetCasa(tabuleiro.posColAtiva, tabuleiro.posLinAtiva); 
		              tabuleiro.posLinAtiva := tabuleiro.posLinAtiva - 1 ;
		              if (tabuleiro.posColAtiva < tabuleiro.quantidadeCasas div 2) then
		              inc(tabuleiro.posColAtiva) else dec(tabuleiro.posColAtiva);
		            end;
			     end; 	               	 
             end;
        #27: begin //Esc      
               if not(tabuleiro.pecaSelecionada) then
               begin
	            case (GerenciaMenu(2)) of 
                   0: Exit;
                   2: if(GerenciaMenu(1) = 0) then Exit;
                   else ;
                 end;
			end   
	          else
	            if not(partida.obrigadoCapturar) then
	            tabuleiro.pecaSelecionada := false;
	        end;
	   #13: begin //ENTER
	          if (not(rede.ativa)) or
	             ((rede.ativa) and (jogador.vez)) then 
	          begin		   
	            if (tabuleiro.pecaSelecionada) then
	            begin
	              textcolor(white);
			    if MovePeca(tabuleiro.posColAtiva, tabuleiro.posLinAtiva) then
			    begin
			      jogador.vez := not(jogador.vez);
			      tabuleiro.pecaSelecionada := false;
			      partida.obrigadoCapturar := false;
			      if (rede.ativa) then EnviaMensagem;
			    end else
			    begin
			      if (partida.obrigadoCapturar) and
				    (tabuleiro.oCol <> tabuleiro.posColAtiva) and 
			         (tabuleiro.oLin <> tabuleiro.posLinAtiva) and 
				    not(tabuleiro.erro) then
			      begin  
			          if (rede.ativa) then EnviaMensagem; 
			      end;
			    end;	                                                         
	            end else
	            begin
	              if ((jogador.vez)  and (tabuleiro.grade[tabuleiro.posColAtiva, tabuleiro.posLinAtiva] = V_1)) or
	                 ((jogador.vez) and (tabuleiro.grade[tabuleiro.posColAtiva, tabuleiro.posLinAtiva] = V_1_D)) or
				  (not(jogador.vez) and (tabuleiro.grade[tabuleiro.posColAtiva, tabuleiro.posLinAtiva] = V_2)) or
	                 (not(jogador.vez) and (tabuleiro.grade[tabuleiro.posColAtiva, tabuleiro.posLinAtiva] = V_2_D)) then
	              begin
	                tabuleiro.origemCol := tabuleiro.posColAtiva;
	                tabuleiro.origemLin := tabuleiro.posLinAtiva;
	                tabuleiro.pecaSelecionada := true;
	              end else
			      tabuleiro.pecaSelecionada := false;
	            end;
	            SelecionaCasa(true);
	            gotoxy(80, 1);
	            delay(100);
	          end;    
		   end; 
	  end; 
	  SelecionaCasa(false);
	  gotoxy(30, (tabuleiro.quantidadeCasas * casa.dimLin) + 3);
	  textcolor(white); textbackground(3) ; 
	  if (tabuleiro.pecaSelecionada) and not(partida.obrigadoCapturar) then
	  write('ESC para soltar peça')
	  else
       write('                    ');
	  gotoxy(80, 1);
     end;
     if (rede.ativa) then
     begin
       if (jogador.vez) then
       begin
         gotoxy(POS_COL_TABULEIRO + (tabuleiro.quantidadeCasas * casa.dimCol) + 2, POS_LIN_TABULEIRO);
         textbackground(3); writeln('        ');
         gotoxy(6, POS_LIN_TABULEIRO + (tabuleiro.quantidadeCasas * casa.dimLin) - 1);
         textbackground(3); textcolor(jogador.cor1); writeln(rede.nick);
       end else
       begin
         gotoxy(6, POS_LIN_TABULEIRO + (tabuleiro.quantidadeCasas * casa.dimLin) - 1);
         textbackground(3); writeln('        ');
         gotoxy(POS_COL_TABULEIRO + (tabuleiro.quantidadeCasas * casa.dimCol) + 2, POS_LIN_TABULEIRO);
         textbackground(3); textcolor(jogador.cor2); writeln(rede.nickOponente);
       end;
       gotoxy(80, 1);
     end;
	if (jogador.quantPecas1 = 0) or (jogador.quantPecas2 = 0) or
	   (rede.mensagem = 'socketLi') then //Finaliza o jogo
	begin
	  DesenhaPainel(19,11,41,8,'Aviso');
	  gotoxy(26, 13);
	  if not(rede.ativa) then
       writeln('Jogo terminado!')
	  else
	  begin
	    if (rede.mensagem = 'socketLi') then
	    begin
	      writeln(rede.nickOponente, ' desistiu!')
	    end else
	    begin	    
	      if(jogador.quantPecas1 = 0) then
	      writeln(rede.nickOponente, ' venceu!')
	      else
	      writeln('Você venceu!');
	    end;   
	  end; 
	  if (partida.sonsAtivos) then write(#7); gotoxy(80, 1);
       readkey; 
       if(GerenciaMenu(1) = 0) then Exit
     end;
     delay(10);
   end;		 	 			    			
 End.
