Unit UnitElementosVisuais;
{Programa sem proprietário.
 Descrição: Esta unidade possui procedimentos de desenho de formas retangulares
 afins e de exibição de texto para leitura com uma certa eficácia.

 Para obter as informações sobre as rotinas confira o escopo da Interface e
 verfique também a explicação contida no cabeçalho de cada procedimento

 ESTA UNIDADE PODE SER REUTILIZADA SEM RESTRIÇÕES :-)    }

Interface
  Uses crt;
  Const
  CARACTERE_PADRAO = #219;

  Procedure DesenhaContorno(posCol, posLin,
                            dimCol, dimLin,
			 	            corLinha, corFundoLinha : integer;
				            sombreamento : boolean);
  Procedure DesenhaRetangulo(caractere : char;
                             posCol, posLin,
                             dimCol, dimLin,
                             cor : integer);
  Procedure DesenhaPainel(posCol, posLin,           
                          dimCol, dimLin : integer;
                          rotulo : string;
                          sombra,
                          contorno : boolean);
  Procedure DesenhaCampo(posCol, posLin,
                         dimCol, dimLin,
                         cor, corFundo, corRotulo : integer;
                         horizontal : boolean;
                         rotulo : string);
  Procedure DesenhaBotao(posCol, posLin,
                         dimCol, dimLin,
                         corFundo, corFundoLinha, corTexto : integer;
                         sombreamento : boolean;
                         texto : string);
  Procedure ExibeTexto(caminho : string;
                       refLin,
                       posCol, posLin,
                       dimCol, dimLin,
                       corTexto, corFundoTexto : integer);
Implementation

 {----------------------------------------------------
     Procedure DesenhaContorno
  -----------------------------------------------------}

 Procedure DesenhaContorno(posCol, posLin,
                           dimCol, dimLin,
				           corLinha, corFundoLinha : integer;
				           sombreamento : boolean);
 {DESENHA O CONTORNO DE UM RETANGULO COM EFEITO DE SOMBRA
  'posCol' e 'posLin' recebem a posição do retângulo
  'dimCol' e 'dimLin' recebem a dimensão do retângulo
  'corLinha' recebe a cor do contorno do retângulo
  'corFundoLinha' recebe a cor de fundo do contorno do retângulo
  'sobreamento' recebe true ou false o que define a posição do sombreamento
  }
 Const
 CARAC_CANTO_NE = #191; CARAC_CANTO_NO = #218;	
 CARAC_CANTO_SE = #217; CARAC_CANTO_SO = #192;	
 CARAC_HORIZONT = #196; CARAC_VERTICAL = #179;
 Var
 cont : integer;
 cor1, cor2 : integer;
 Begin 
   cont := 0;
   if (corLinha = 16) or (corLinha = 0) then
   begin
     if (sombreamento) then
     begin cor1 := 0; cor2 := 15; end
     else
     begin cor2 := 0; cor1 := 15; end;
   end else
   if (sombreamento) then
   begin cor1 := corLinha; cor2 := corLinha + 8; end 
   else 
   begin cor2 := corLinha; cor1 := corLinha + 8; end;
   textBackGround(corFundoLinha);
   while (cont < dimCol - 1) or (cont < dimLin - 1) do
   begin 
     if (cont < dimCol - 1) then
     begin
       textColor(cor1);
       goToXY(posCol + cont, posLin); if (cont > 0) then 
	  write(CARAC_HORIZONT) else write(CARAC_CANTO_NO); //LINHA HORIZONTAL NORTE - ARESTA NOROESTE
	  textColor(cor2);
       goToXY(posCol + dimCol - cont - 1, posLin + dimLin - 1) ; if (cont > 0) then
	  write(CARAC_HORIZONT) else write(CARAC_CANTO_SE); //LINHA HORIZONTAL NORTE - ARESTA SUDESTE 
     end;
	if (cont < dimLin - 1) then
	begin 
	  textColor(cor1); 
       goToXY(posCol, posLin + dimLin - cont - 1); if (cont > 0) then
	  write(CARAC_VERTICAL) else write(CARAC_CANTO_SO); //LINHA VERTICAL OESTE - ARESTA SUDOESTE
	  textColor(cor2);
       goToXY(posCol + dimCol - 1, posLin + cont); if (cont > 0) then 
	  write(CARAC_VERTICAL) else write(CARAC_CANTO_NE); //LINHA VERTICAL LESTE - ARESTA NOROESTE
     end;
	inc(cont);
   end;
   textColor(black);
 End;

 {----------------------------------------------------
     Procedure DesenhaRetangulo
  -----------------------------------------------------}
 Procedure DesenhaRetangulo(caractere : char;
                            posCol, posLin,
                            dimCol, dimLin,
                            cor : integer);
 {DESENHA UM RETÂNGULO MACIÇO
  'caractere' recebe o caractere que preencherá todo o retângulo
  'posCol' e 'posLin' recebem a posição do retângulo
  'dimCol' e 'dimLin' recebem a dimensão do retângulo
  'cor' recebe a cor do retângulo}
 Var
 cont : integer; linha : string;
 Begin
   textcolor(cor) ;
   textbackground(cor) ;
   linha := '';
   for cont := 1 to dimCol do
   if (cont > 1) then
   linha := concat(linha, caractere)
   else
   linha := caractere;
   for cont := 1 to dimLin do
   begin
     gotoxy(posCol, posLin + cont - 1) ;
     write(linha);
   end;
 End;

 {----------------------------------------------------
     Procedure DesenhaPainel
  -----------------------------------------------------}
 Procedure DesenhaPainel(posCol, posLin,           
                         dimCol, dimLin : integer;
                         rotulo : string;
                         sombra, 
                         contorno : boolean);
 {DESENHA UM PAINEL SOMBREADO COM UM NOME
  'posCol' e 'posLin' recebem a dimensão do retãngulo
  'dimCol' e 'dimLin' recebem a dimensão do retângulo
  'rotulo' recebe o título que aparecerá no topo do painel à esquerda
  'sombra' recebe true ou false o que determina a presença da sombra atrás do painel
  'contorno' recebe true ou false o que determina a presença do contorno sobre o painel}
 Begin
   if sombra then
   begin
     DesenhaRetangulo(CARACTERE_PADRAO, posCol + dimCol , posLin + 1, 2, dimLin - 1, 16);
     DesenhaRetangulo(CARACTERE_PADRAO, posCol + 2, posLin + dimLin, dimCol, 1, 16);
   end;
   DesenhaRetangulo(CARACTERE_PADRAO, posCol, posLin + 1, dimCol, dimLin - 1, 7);
   if contorno then
   DesenhaContorno(posCol, posLin + 1, dimCol, dimLin - 1, 16, 7, false);
   DesenhaRetangulo(CARACTERE_PADRAO, posCol, posLin, dimCol, 1, 1);
   textColor(15); textBackGround(1);
   goToXY(posCol + 1, posLin); write(rotulo);
   textColor(16); textBackGround(7);				
 End;

 {----------------------------------------------------
     Procedure DesenhaCampo
  -----------------------------------------------------}
 Procedure DesenhaCampo(posCol, posLin,
                        dimCol, dimLin,
                        cor, corFundo, corRotulo : integer;
                        horizontal : boolean;
                        rotulo : string);
 {DESENHA UM CAMPO COM UM RÓTULO
  'posCol' e 'posLin' recebem a posição do campo
  'dimCol' e 'dimLin' recebem a dimensão do campo
  'cor' recebe a cor das linhas do campo
  'corFundo' recebe a cor de fundo das linhas do campo
  'corRotulo' recebe a cor do rótulo do campo
  'horizontal' recebe true ou false o que determina a posição do rótulo em relação ao campo
  'rotulo' recebe o rotulo do campo}
 Begin
   dimCol := dimCol + 2;
   dimLin := dimLin + 2;
   textbackground(corFundo);
   if horizontal then
   begin
     gotoxy(posCol, posLin + dimLin div 2);
     textcolor(corRotulo); write(rotulo);
     DesenhaContorno(posCol + length(rotulo), posLin, dimCol, dimLin, cor, corFundo, true);
   end else
   begin
     gotoxy(posCol + 1, posLin);
     textcolor(corRotulo); write(rotulo);
     DesenhaContorno(posCol, posLin + 1, dimCol, dimLin, cor, corFundo, true);
   end;
 End;

 {----------------------------------------------------
     Procedure DesenhaBotao
  -----------------------------------------------------}
 Procedure DesenhaBotao(posCol, posLin,
                        dimCol, dimLin,
                        corFundo, corFundoLinha, corTexto : integer;
                        sombreamento : boolean;
                        texto : string);
 {DESENHA O CONTORNO SOMBREADO DE UM RETÂNGULO COM UM TEXTO NO CENTRO
  'posCol' e 'posLin' recebem a posição do botão
  'posCol e 'posLin' recebem a dimensão da janela
  'corFundo' recebe a cor de fundo do botão
  'corFundoLinha' recebe a cor de fundo das linha
  'corTexto' recebe a cor do texto do botão
  'sombreamento' recebe true ou false que determina a posição da sombra (isso determina o efeito de pressionamento)
  'texto' recebe a string que será exibida no centro do botão}
 Begin
   dimCol := dimCol + 2; dimLin := dimLin + 2;
   DesenhaContorno(posCol, posLin, dimCol, dimLin, 16, corFundoLinha, sombreamento);
   DesenhaRetangulo(CARACTERE_PADRAO, posCol + 1, posLin + 1, dimCol - 2, dimLin - 2, corFundo);
   if (length(texto) > (dimCol - 2)) then texto := copy(texto, 1, dimCol - 2);
   gotoxy(posCol + (dimCol div 2) - (length(texto) div 2), posLin + (dimLin div 2));
   textcolor(corTexto); textbackground(corFundo); write(texto);
 End;

 {----------------------------------------------------
     Procedure ExibeTexto
  -----------------------------------------------------}
 Procedure ExibeTexto(caminho : string;
                      refLin,
                      posCol, posLin,
                      dimCol, dimLin,
                      corTexto, corFundoTexto : integer);
 {CARREGA UM ARQUIVO DE TEXTO O EXIBE NOS LIMITES DEFINIDOS
  'caminho' recebe a string contendo o caminho até o arquivo
  'refLin' recebe a referencia da linha do arquivo a partir da qual ele será exibido
  'posCol' e 'posLin' recebem a posicao de tela a partir da qual o texto será exibido
  'dimCol' e 'dimLin' recebem a dimensao dos limites da exibição do texto na tela
  'corTexto' recebe a cor do texto
  'corFundoTexto' recebe a cor do fundo do texto}
 Var
 linha : string;
 contA : integer;
 arq : text;
 Begin
   assign(arq, caminho);
   {$I-} reset(arq); {$I+}
   if ioresult = 0 then
   begin
     for contA := 1 to refLin - 1 do
     begin
       readln(arq, linha);
     end;
     for contA := 1 to dimLin do
     begin
       readln(arq, linha);
       textcolor(corTexto); textbackground(corFundoTexto);
       gotoxy(posCol, posLin + contA - 1);
       if length(linha) > dimCol then
       linha := copy(linha, 1, dimCol);
       write(linha);
       if length(linha) < dimCol then
       DesenhaRetangulo(CARACTERE_PADRAO, posCol + length(linha), posLin + contA - 1, dimCol - length(linha), 1, corFundoTexto);
     end;
     close(arq);
   end else
   begin
     textcolor(yellow); textbackground(red);
     gotoxy(posCol, posLin); write('!ERRO:FICHEIRO_AUSENTE!');
   end;

 End;

End.
