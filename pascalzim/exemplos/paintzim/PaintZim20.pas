Program PaintZim20 ;
{ -------------------------------------------------------------
   Programa que implementa um editor de imagens ASCII :~
   PaintZim - versão 2.0

   Autor : GRSa
   O programa é uma cortesia ao querido Pascalzim.

 -------------------------------------------------------------

   Características e funcionalidades:

   O PaintZim é uma ferramenta para edição de ASCII Art.
   Manipula caracteres e cores para criação de desenhos baseados em ASCII.
   O programa dispõe de uma extensa área editável através de uma página rolável.
   É possível exportar os trabalhos para HTML ou para código em pascal.
   É possível importar caracteres de um arquivo de texto para trabalhar
   à partir deles.

   Notas da segunda versão:

   **A segunda versão do PaintZim conta com o conceito de seleção. Com isso
   é possível manipular grandes quantidade de caracteres de uma única vez.
   **Foi implementado suporte aos comandos Copiar e Colar e Desfazer e Refazer.
   **O programa foi incrementado com uma interface mais limpa e intuitiva.
   **Foi implementado a opção de exportar para código pascal, assim os desenhos
   podem ser transformados em código para serem reaproveitados em outros programas.
   **Foi adicionado cor aos desenhos exportados para HTML.
   **Foi adicionado a função de importar caracteres de arquivos de texto.

   Lista das rotinas em ordem:

   Procedure DesenhaContorno;
   Procedure DesenhaRetangulo;
   Procedure DesenhaPainel;
   Procedure DesenhaCampo;
   Function ObtemTeclaPressionada;
   Function LeDado;
   Function IntParaString;
   Function IntParaString;
   Function ObtemCadeia;
   Procedure ExibeTela;
   Procedure ExibeInformacao;
   Procedure MostraCursor;
   Procedure ExibeLimitesSelecao;
   Procedure InicializaDefinicoes;
   Procedure IncrementaHistoricoDesfazer;
   Procedure IncrementaHistoricoRefazer;
   Procedure DesfazUltimaAcao;
   Procedure RefazUltimaAcao;
   Procedure InsereElemento;
   Procedure RedefineFundoPagina;
   Procedure SelecionaCaractere;
   Procedure SelecionaCor;
   Procedure DefineAtalhos;
   Procedure GerenciaSelecao;
   Procedure ColaSelecao;
   Procedure ManipulaAreaSelecionada;
   Function RetornaReferencia;
   Function SalvaArquivoPaintZim20;
   Function CarregaArquivoPaintZim20;
   Function ExportaArquivoHTML;
   Function ExportaCodigoPascal;
   Function ImportaArquivoTXT;
   Procedure GerenciaMenu;


   Estrutura do arquivo paintzim

   Um arquivo paintzim possui um desenho/texto salvo pelo editor do programa.
   O arquivo gerado e carregado pelo PaintZim20 é estruturado de forma a
   armazenar os dados necessários dos trabalhos feitos no editor.
   O arquivo padrão manipulado pelo PaintZim20 possui a extensão .paintzim.
   Os dados são armazenados, quase que completamente, de forma numérica, ou seja
   através de números. A organização dos dados é feita da seguinte forma:

     As três primeiras linhas formam o cabeçalho do arquivo. E tem a seguinte
     estrutura:
     Versão do arquivo: "Arquivo PaintZim20"
     Estado do editor, no formato: AAABBBCCC
     Limites do desenho, no formato: DDDEEEFFFGGG
        AAA - Cor de fundo
        BBB - Posicao na coluna da página
        CCC - Posicao na linha da página

        DDD - Limite oeste do desenho na página (Coluna esquerda)
        EEE - Limite leste do desenho na página (Coluna direita)
        FFF - Limite norte do desenho na página (Linha superior)
        GGG - Limite sul do desenho na página (Linha inferior)

     As outras linhas após o cabeçalho armazenarão um registro por vez contendo
     os dados de cada "pixel" (caractere e seus atributos de cor) do desenho.
     Registro, no formato: HHHIIIJJJKKKLLL
        HHH - Posicão na coluna na página
        III - Posição na linha da página
        JJJ - Caractere
        KKK - Cor do caractere
        LLL - Cor de fundo do caractere

   O FORMATO PAINTZIM NÃO POSSUI PROPRIETÁRIO, PORTANTO PODE SER REUTILIZADO SEM
   RESTRIÇÕES, INCLUSIVE MODIFICADO SEM QUE HAJA PREJUÍZOS LEGAIS.

 ------------------------------------------------------------- }
 Uses crt;

 {----------------------------------------------------
     CONSTANTES, VARIÁVEIS E REGISTROS
  ----------------------------------------------------}
 Const
 
 DIMENSAO_COL_TELA = 80 ; //Dimensão da tela (Col)
 DIMENSAO_LIN_TELA = 23 ; //Dimensão da tela (Lin)
 DIMENSAO_COL_PAGINA = 160 ; //Dimensão da página (Col)
 DIMENSAO_LIN_PAGINA = 80 ; //Dimensão da página (Lin)
 POSICAO_COL_TELA = 1 ; //Posição da tela no prompt (Col)
 POSICAO_LIN_TELA = 2 ; //Posição da tela no prompt (Lin)

 DIMENSAO_HISTORICO = DIMENSAO_COL_PAGINA * DIMENSAO_LIN_PAGINA * 4;
 DIMENSAO_AREA_TRANSFERENCIA = DIMENSAO_COL_PAGINA * DIMENSAO_LIN_PAGINA;

 TEMPO_MAX_TEMPORIZADOR = 20;

 COR_PAINEL = 7; //Cor do painel
 CARACTERE_NULO = 255; //Caractere nulo
 EXT_ARQUIVO_PAINTZIM = 'paintzim'; //Extensão do arquivo editável
 EXT_ARQUIVO_HTML = 'html';
 EXT_ARQUIVO_PASCAL = 'pas';
 NULO = '\NULO';

 //CONSTANTES DE TECLAS
 TECLA_UP = '072';
 TECLA_DOWN = '080';
 TECLA_RIGHT = '077';
 TECLA_LEFT = '075';
 TECLA_DELETE = '083';
 TECLA_ENTER = '13';
 TECLA_ESC = '27';
 TECLA_BACKSPACE = '8';
 TECLA_TAB = '9';
 TECLA_SPACE = '32';
 TECLA_F1 = '059'; {TECLA_F2 = '060';}
 TECLA_F3 = '061'; TECLA_F4 = '062';
 TECLA_F5 = '063'; TECLA_F6 = '064';
 {TECLA_F7 = '065'; TECLA_F8 = '066';}
 TECLA_F9 = '067'; TECLA_F10 = '068';
 {TECLA_F11 = '0133';} TECLA_F12 = '0134';
 TECLA_0 = '48'; TECLA_1 = '49';
 TECLA_2 = '50'; TECLA_3 = '51';
 TECLA_4 = '52'; TECLA_5 = '53';
 TECLA_6 = '54'; TECLA_7 = '55';
 TECLA_8 = '56'; TECLA_9 = '57';
 TECLA_CTRL_UP = '0141';
 TECLA_CTRL_DOWN = '0145';
 TECLA_CTRL_RIGHT = '0116';
 TECLA_CTRL_LEFT = '0115';
 {TECLA_CTRL_ALT_UP = '0152';
 TECLA_CTRL_ALT_DOWN = '0160';
 TECLA_CTRL_ALT_RIGHT = '0157';
 TECLA_CTRL_ALT_LEFT = '0155';}
 TECLA_CTRL_E = '5';
 TECLA_CTRL_Z = '26';
 TECLA_CTRL_R = '18';
 TECLA_CTRL_T = '20';
 TECLA_CTRL_V = '22';
 TECLA_CTRL_L = '12';
 TECLA_CTRL_B = '2';
 TECLA_CTRL_ALT_B = '048';
 TECLA_CTRL_A = '1';
 TECLA_ALT_V = '047';
 TECLA_CTRL_ENTER = '10';
 TECLA_CTRL_ALT_ENTER = '0166';

  Type
   ElementoImagem = Record
                     caractere,
                     cor, corFundo : integer;
                    End;
   ElementoHistorico = Record
                         ciclo, posCol, posLin : integer;
                         elemento : ElementoImagem;
                       End;
   ElementoAreaTransferencia = Record
                                 posCol, posLin : integer;
                                 elemento : ElementoImagem;
                               End;

 Var
   matriz : Record
              pagina : array [1..DIMENSAO_COL_PAGINA + 1, 1..DIMENSAO_LIN_PAGINA + 1] of ElementoImagem;
              tela : array [1..DIMENSAO_COL_TELA + 1, 1..DIMENSAO_LIN_TELA + 1] of ElementoImagem;
            End;
   editor : Record
              corFundo,
              corFundoCaractere,
              corCaractere : integer; {Manipulados em Procedure SelecionaCor}
              caractere : integer;
              temporizador : integer;
              grupoPredefinido : array [0..9] of integer;
              refGrupoPredefinido : integer;
              modoContinuo, modoAtalho : boolean;
              nomeArquivo, nomeArquivoAux : string;
              arquivoAberto : boolean;
            End;
  selecao : Record
              posCol, posLin : integer;
              dimCol, dimLin : integer;
              ativa : boolean;
              cachePosColCursor, cachePosLinCursor : integer;
              cacheRefColPagina, cacheRefLinPagina : integer;
            End;
   cursor : Record
              posCol, posLin : integer;
              formato : ElementoImagem;
            End;
   definicao : Record
                 refColPagina, refLinPagina : integer;
                 finalizarPrograma : boolean;
                 tecla : string[5];
               End;
   historico : Record
                 lista : array[1..DIMENSAO_HISTORICO] of ElementoHistorico;
                 quantElementosDesfazer, quantElementosRefazer : integer;
                 refListaDesfazer, refListaRefazer : integer;
                 refCicloDesfazer, refCicloRefazer : integer;
                 trocarCiclo : boolean;
               End;
 areaTransferencia : Record
                       matriz : array[1..DIMENSAO_AREA_TRANSFERENCIA] of ElementoAreaTransferencia;
                       quantElementos : integer;
                     End;

 {----------------------------------------------------
     Procedure DesenhaContorno;
  -----------------------------------------------------}
 Procedure DesenhaContorno(posCol, posLin,
                           dimCol, dimLin,
				           corLinha, corFundoLinha : integer;
				           sombreamento : boolean);
 Const
 CARAC_CANTO_NE = #191; CARAC_CANTO_NO = #218;	
 CARAC_CANTO_SE = #217; CARAC_CANTO_SO = #192;	
 CARAC_HORIZONT = #196; CARAC_VERTICAL = #179;
 Var
 cont : integer;
 cor1, cor2 : integer;
 Begin 
   cont := 0;
   if (sombreamento) then 
   begin cor1 := corLinha; cor2 := corLinha + 8; end 
   else 
   begin cor2 := corLinha; cor1 := corLinha + 8; end;
   textBackGround(corFundoLinha) ;
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
     Procedure DesenhaRetangulo;
  -----------------------------------------------------}
 Procedure DesenhaRetangulo(posCol, posLin,
                            dimCol, dimLin,
                            cor : integer);
 {DESENHA UM RETÂNGULO MACIÇO COM O TAMANHO DE SEU PERÍMETRO
  'posCol' e 'posLin' recebem a posição do retângulo
  'dimCol' e 'dimLin' recebem a dimensão do retângulo
  'cor' recebe a cor do retângulo}
 Const
 CARAC_PADRAO = #219;
 Var
 cont : integer; linha : string;
 Begin
   textcolor(cor) ;
   textbackground(cor) ;
   linha := '';
   for cont := 1 to dimCol do
   if (cont > 1) then
   linha := concat(linha, CARAC_PADRAO)
   else
   linha := CARAC_PADRAO;
   for cont := 1 to dimLin do
   begin
     gotoxy(posCol, posLin + cont - 1) ;
     write(linha);
   end;
 End;

 {----------------------------------------------------
     Procedure DesenhaPainel;
  -----------------------------------------------------}
 Procedure DesenhaPainel(posCol, posLin,           
                         dimCol, dimLin : integer;
				         rotulo : string);
 {DESENHA UM PAINEL SOMBREADO COM UM NOME
  'posCol' e 'posLin' recebem a dimensão do retãngulo
  'dimCol' e 'dimLin' recebem a dimensão do retângulo
  'cor' recebe a cor do retângulo}
 Begin
   DesenhaRetangulo(posCol + dimCol , posLin + 1, 2, dimLin - 1, 16);
   DesenhaRetangulo(posCol + 2, posLin + dimLin, dimCol, 1, 16);
   DesenhaRetangulo(posCol, posLin + 1, dimCol, dimLin - 1, 7);
   DesenhaContorno(posCol, posLin + 1, dimCol, dimLin - 1, 16, 7, false);
   DesenhaRetangulo(posCol, posLin, dimCol, 1, 1);
   textColor(15); textBackGround(1);
   goToXY(posCol + 1, posLin); write(rotulo);
   textColor(16); textBackGround(7);				
 End;

 {----------------------------------------------------
     Procedure DesenhaCampo;
  -----------------------------------------------------}
 Procedure DesenhaCampo(posCol, posLin,
                        dimCol, dimLin,
                        cor, corFundo, corRotulo : integer;
                        horizontal : boolean;
                        rotulo : string);
 {DESENHA UM CAMPO COM UM RÓTULO
  'posCol' e 'posLin' recebem a posição do campo
  'dimCol' e 'dimLin' recebem a dimensão do campo
  'cor' recebe a cor do campo
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
     Function ObtemTeclaPressionada;
  -----------------------------------------------------}
  Function ObtemTeclaPressionada : string;
  {RETORNA A REFERENCIA À TECLA PRESSIONADA}
  Const
  COMANDO_ACENTUACAO_1 = #26;
  COMANDO_ACENTUACAO_2 = #40;
  Var
  refA, refB : char;
  tecla, auxA, auxB : string;
  Begin
    if (keypressed) then
    begin
      refA := readkey;
      case upcase(refA) of
          #0 : begin
                 refB := readkey;
                 if (refB <> COMANDO_ACENTUACAO_1) and
                    (refB <> COMANDO_ACENTUACAO_2) then
                 begin
                   str(ord(refA), auxA);
                   str(ord(refB), auxB);
                   tecla := concat(auxA, auxB);
                 end else
                 tecla := NULO;
               end;
        else begin
               str(ord(refA), auxA);
               tecla := auxA;
             end;
      end;
    end else
    begin
      tecla := NULO;
    end;
    ObtemTeclaPressionada := tecla;
  End;

 {----------------------------------------------------
     Function LeDado;
  -----------------------------------------------------}
  Function LeDado (var varRec : string;
                   dimString : integer) : string;
 {LÊ UM DADO SEM ULTRAPASSAR O LIMITE DA DIMENSÃO DA STRING
  'varRec' recebe a referência a variável que irá receber o dado lido
  'dimString' recebe a dimensão da string que será lida}
  Const
  CARAC_NULO = #255;
  Var
  dimCadeia, refTecla, codErro, intA : integer;
  tecla, cadeia : string;
  carac : char;
  Begin
    dimCadeia := 0;
    cadeia := '';
    CursorOn;
    while (true) do
    begin
      tecla := ObtemTeclaPressionada;
      if tecla <> NULO then
      begin
        if tecla <> TECLA_ESC then
        begin
          if (tecla <> TECLA_ENTER) and
             (tecla <> TECLA_TAB) then
          begin
            if tecla <> TECLA_BACKSPACE then
            begin
              if (tecla <> TECLA_UP) and
                 (tecla <> TECLA_DOWN) and
                 (tecla <> TECLA_RIGHT) and
                 (tecla <> TECLA_LEFT) then
              begin
                if dimCadeia < dimString then
                begin
                  inc(dimCadeia);
                  gotoxy(whereX, whereY);
                  val(tecla, refTecla, codErro);
                  carac := chr(refTecla);
                  cadeia := concat(cadeia, carac);
                  write(carac);
                end;
              end;
            end else
            begin
              if dimCadeia > 0 then
              begin
                gotoxy(whereX - 1, whereY);
                write(CARAC_NULO);
                dec(dimCadeia);
                gotoxy(whereX - 1, whereY);
                cadeia := copy(cadeia, 1, length(cadeia) - 1);
              end;
            end;
          end else
          begin
            if dimCadeia > 0 then
            begin
              varRec := cadeia;
              val(cadeia, intA, codErro);
              str(codErro, cadeia);
              LeDado := cadeia;
              CursorOff;
              break;
            end;
          end;
        end else
        begin
          LeDado := NULO;
          CursorOff;
          break;
        end;
      end;

    end;

  End;

 {----------------------------------------------------
     Function IntParaString;
  -----------------------------------------------------}
  Function IntParaString (num : integer) : string;
  Var
  resultado : string;
  Begin
    str(num, resultado);
    IntParaString := resultado;
  End;

 {----------------------------------------------------
     Function StringParaInt;
  -----------------------------------------------------}
  Function StringParaInt (cadeia : string) : integer;
  Var
  resultado : integer;
  codErro : integer;
  Begin
    val(cadeia, resultado, codErro);
    StringParaInt := resultado;
  End;

 {----------------------------------------------------
     Function ObtemCadeia;
  -----------------------------------------------------}
 Function ObtemCadeia (rotulo1, rotulo2 : string): string;
 Const
 POSICAO_COL_PAINEL = 2;
 POSICAO_LIN_PAINEL = 16;
 DIMENSAO_NOME = 50;
 Var
 dadoLido : string;
 Begin
   DesenhaPainel(POSICAO_COL_PAINEL, POSICAO_LIN_PAINEL, DIMENSAO_NOME + 4, 7, rotulo1);
   DesenhaCampo(POSICAO_COL_PAINEL + 1, POSICAO_LIN_PAINEL + 2, DIMENSAO_NOME, 1, 16, 7, 16, false, rotulo2);
   gotoxy(POSICAO_COL_PAINEL + 2, POSICAO_LIN_PAINEL + 4);
   textcolor(16); textbackground(7);
   if LeDado(dadoLido, DIMENSAO_NOME) <> NULO then
   ObtemCadeia := dadoLido
   else
   ObtemCadeia := NULO;
 End;

 {----------------------------------------------------
     Procedure ExibeTela;
  -----------------------------------------------------}
 Procedure ExibeTela (posCol, posLin : integer;
                      exibeTudo : boolean);
 Var
 col, lin : integer;
 Begin
   if ((posCol+DIMENSAO_COL_TELA-1) <= DIMENSAO_COL_PAGINA) and
      ((posLin+DIMENSAO_LIN_TELA-1) <= DIMENSAO_COL_PAGINA) and
      (posCol > 0) and  (posLin > 0)
   then
   begin
     for lin := 1 to DIMENSAO_LIN_TELA do
       for col := 1 to DIMENSAO_COL_TELA do
       begin
         if (matriz.pagina[posCol-1+col, posLin-1+lin].caractere <> matriz.tela[col, lin].caractere) or
		    (matriz.pagina[posCol-1+col, posLin-1+lin].cor <> matriz.tela[col, lin].cor) or
	        (matriz.pagina[posCol-1+col, posLin-1+lin].corFundo <> matriz.tela[col, lin].corFundo) or
            (exibeTudo) then
         begin
           matriz.tela[col, lin].caractere := matriz.pagina[posCol-1+col, posLin-1+lin].caractere;
           matriz.tela[col, lin].cor := matriz.pagina[posCol-1+col, posLin-1+lin].cor;
		   matriz.tela[col, lin].corFundo := matriz.pagina[posCol-1+col, posLin-1+lin].corFundo;
           gotoxy(POSICAO_COL_TELA-1+col, POSICAO_LIN_TELA-1+lin);
           textcolor(matriz.tela[col, lin].cor); textbackground(matriz.tela[col, lin].corFundo) ;
           write(chr(matriz.tela[col, lin].caractere));
         end;
       end ;
   end;
 End;
 {Procedure ExibeTela (posCol, posLin : integer;
                      tudo : boolean);
 Var
 col, lin : integer;
 elementoAtual: ElementoImagem;
 buffer : record
            cadeia : string[DIMENSAO_COL_TELA];
            cadeiaVazia : boolean;
            posicao, cor, corFundo : integer;
          end;

   Function CaractereJaDefinido(posC, posL : integer;
                                elemento : ElementoImagem) : boolean;
   Begin
     if (matriz.tela[posC, posL].caractere = elemento.caractere) and
        (matriz.tela[posC, posL].cor = elemento.cor) and
        (matriz.tela[posC, posL].corFundo = elemento.corFundo) then
     CaractereJaDefinido := true
     else
     CaractereJaDefinido := false;
   End;

   Function UltimoCaractereDaLinha : boolean;
   Begin
     if col = DIMENSAO_COL_TELA then
     UltimoCaractereDaLinha := true
     else
     UltimoCaractereDaLinha := false;
   End;

   Function CaractereTipoBuffer(elemento : ElementoImagem) : boolean;
   Begin
     if (elemento.cor = buffer.cor) and
        (elemento.corFundo = buffer.corFundo) then
     CaractereTipoBuffer := true
     else
     CaractereTipoBuffer := false;
   End;

   Procedure IncrementaBuffer(elemento : ElementoImagem);
   Begin
     if buffer.cadeiaVazia then
     begin
       buffer.cadeia := chr(elemento.caractere);
       buffer.cadeiaVazia := false;
       buffer.cor := elemento.cor;
       buffer.corFundo := elemento.corFundo;
       buffer.posicao := col;
     end else
     begin
       buffer.cadeia := buffer.cadeia + chr(elemento.caractere);
     end;
   End;

   Procedure LiberaBuffer;
   Begin
     gotoxy(POSICAO_COL_TELA - 1 + buffer.posicao, POSICAO_LIN_TELA - 1 + lin);
     textcolor(buffer.cor); textbackground(buffer.corFundo);
     write(buffer.cadeia);
     buffer.cadeiaVazia := true;
   End;

   Procedure AtualizaPosicao;
   Begin
     matriz.tela[col, lin] := elementoAtual;
   End;

 Begin
   if ((posCol + DIMENSAO_COL_TELA - 1) <= DIMENSAO_COL_PAGINA) and
      ((posLin + DIMENSAO_LIN_TELA - 1) <= DIMENSAO_LIN_PAGINA) and
      (posCol > 0) and (posLin > 0) then
   begin

     if tudo then
     begin
       for lin := 1 to DIMENSAO_LIN_TELA do
       for col := 1 to DIMENSAO_COL_TELA do
       begin
         matriz.tela[col, lin].cor := matriz.tela[col, lin].cor + 1;
         matriz.tela[col, lin].corFundo := matriz.tela[col, lin].corFundo + 1;
       end;
     end;

     buffer.cadeiaVazia := true;

     for lin := 1 to DIMENSAO_LIN_TELA do
     begin

       for col := 1 to DIMENSAO_COL_TELA do
       begin

         elementoAtual := matriz.pagina[posCol - 1 + col, posLin - 1 + lin];

         if CaractereJaDefinido(col, lin, elementoAtual) then
         begin
           if not(buffer.cadeiaVazia) then
           LiberaBuffer;
         end else
         begin
           if buffer.cadeiaVazia then
           begin
             IncrementaBuffer(elementoAtual);
             if UltimoCaractereDaLinha then
             LiberaBuffer;
             AtualizaPosicao;
           end else
           begin
             if CaractereTipoBuffer(elementoAtual) then
             begin
               IncrementaBuffer(elementoAtual);
               if UltimoCaractereDaLinha then
               LiberaBuffer;
               AtualizaPosicao;
             end else
             begin
               LiberaBuffer;
               IncrementaBuffer(elementoAtual);
               if UltimoCaractereDaLinha then
               LiberaBuffer;
               AtualizaPosicao;
             end;
           end;
         end;
       end;
     end;
   end;
 End;}

 {----------------------------------------------------
     Procedure ExibeInformacao;
  -----------------------------------------------------}
 Procedure ExibeInformacao (refInformacao : string);
   Var
   cadeia : string;
   posCol, posLin : integer;
   Procedure LimpaPainel;
   Begin
     DesenhaRetangulo(POSICAO_COL_TELA, POSICAO_LIN_TELA + DIMENSAO_LIN_TELA,
                      DIMENSAO_COL_TELA - 1, 1, COR_PAINEL);
     gotoxy(POSICAO_COL_TELA + 1, POSICAO_LIN_TELA + DIMENSAO_LIN_TELA);
     textcolor(black); textbackground(COR_PAINEL);
   End;
 Begin

   if (refInformacao = 'PAINEL_CABECALHO_1') then
   begin
     gotoxy(1, 1);
     textcolor(black); textbackground(COR_PAINEL);
     write(' ',#16,'PaintZim20           Ctrl+A=Abrir  Ctrl+B=Salvar  Ctrl+E=Exportar  Esc=Fechar');
   end else
   if (refInformacao = 'PAINEL_CABECALHO_2') then
   begin
     gotoxy(1, 1);
     textcolor(black); textbackground(COR_PAINEL);
     write(' ',#16,'PaintZim20                                                                   ');
   end else
   if (refInformacao = 'PAINEL_PADRAO') then
   begin
     LimpaPainel;
     write('Digite ou insira caracteres com o Enter  F9=Cores  F1=Ajuda');
   end else
   if (refInformacao = 'PAINEL_SELECAO') then
   begin
     LimpaPainel;
     write('Dimensione a area da selecao com as setas e pressione Enter  Esc=Sair');
   end else
   if (refInformacao = 'PAINEL_MENU_GENERICO') then
   begin
     ExibeInformacao('PAINEL_CABECALHO_2');
     LimpaPainel;
     write('Escolha uma opcao e pressione Enter  Esc=Sair');
   end else
   if (refInformacao = 'PAINEL_CONFIRMACAO') then
   begin
     ExibeInformacao('PAINEL_CABECALHO_2');
     LimpaPainel;
     write('Pressione qualquer tecla para continuar');
   end else
   if (refInformacao = 'PAINEL_OBTER_DADO') then
   begin
     ExibeInformacao('PAINEL_CABECALHO_2');
     LimpaPainel;
     write('Digite um nome para o arquivo sem a extensao  ESC=Sair');
   end else
   if (refInformacao = 'PAINEL_COR_CARACTERE') then
   begin
     ExibeInformacao('PAINEL_CABECALHO_2');
     LimpaPainel;
     write('Selecione as cores e pressione Enter  Esc=Sair  Tab=Alternar');
   end else
   if (refInformacao = 'PAINEL_COR_PAGINA') then
   begin
     ExibeInformacao('PAINEL_CABECALHO_2');
     LimpaPainel;
     write('Selecione a cor e pressione Enter  Esc=Sair');
   end else
   if (refInformacao = 'PAINEL_CARACTERE') then
   begin
     ExibeInformacao('PAINEL_CABECALHO_2');
     LimpaPainel;
     write('Selecione o caractere e pressione Enter  Esc=Sair');
   end else
   if (refInformacao = 'PAINEL_CONFIRMACAO_SALVAMENTO') then
   begin
     LimpaPainel;
     write('Todas as alteracoes foram salvas');
     delay(1000);
   end else
   if (refInformacao = 'PAINEL_ATALHOS') then
   begin
     LimpaPainel;
     write('0=', chr(editor.grupoPredefinido[0]), '  1=', chr(editor.grupoPredefinido[1]),
           '  2=', chr(editor.grupoPredefinido[2]), '  3=', chr(editor.grupoPredefinido[3]),
           '  4=', chr(editor.grupoPredefinido[4]), '  5=', chr(editor.grupoPredefinido[5]),
           '  6=', chr(editor.grupoPredefinido[6]), '  7=', chr(editor.grupoPredefinido[7]),
           '  8=', chr(editor.grupoPredefinido[8]), '  9=', chr(editor.grupoPredefinido[9]),
           '  F1=Ajuda');
   end else
   if (refInformacao = 'PAINEL_BOM_AVISO') then
   begin
     ExibeInformacao('PAINEL_CABECALHO_2');
     LimpaPainel;
     textcolor(yellow); textbackground(red);
     write('Programa criado como cortesia para o querido Pascalzim :-)');
   end else
   if (refInformacao = 'PAINEL_STATUS') then
   begin
     textcolor(8); textbackground(COR_PAINEL);
     cadeia := concat('    ',IntParaString(definicao.refColPagina - 1 + cursor.posCol),',',
                      IntParaString(definicao.refLinPagina - 1 + cursor.posLin));
     gotoxy(DIMENSAO_COL_TELA - length(cadeia) - 5, POSICAO_LIN_TELA + DIMENSAO_LIN_TELA);
     write(cadeia);
     textcolor(editor.corCaractere); textbackground(editor.corFundoCaractere);
     gotoxy(DIMENSAO_COL_TELA - 3, POSICAO_LIN_TELA + DIMENSAO_LIN_TELA);
     write(#32, chr(editor.caractere), #32);
   end else
   if (refInformacao = 'PAINEL_DIMENSAO_SELECAO') then
   begin
     textcolor(lightred); textbackground(COR_PAINEL);
     cadeia := concat('   ',IntParaString(selecao.dimCol), 'x', IntParaString(selecao.dimLin));
     gotoxy(DIMENSAO_COL_TELA - length(cadeia), POSICAO_LIN_TELA + DIMENSAO_LIN_TELA);
     write(cadeia);
   end else
   if (refInformacao = 'ERRO_GERAR_ARQUIVO') then
   begin
     posCol := 52; posLin := 3;
     DesenhaPainel(posCol, posLin, 24, 5, 'Erro');
     ExibeInformacao('PAINEL_CONFIRMACAO');
     textcolor(black); textbackground(COR_PAINEL);
     gotoxy(posCol + 1, posLin + 2);
     write('Ocorreu um problema ao');
     gotoxy(posCol + 1, posLin + 3);
     write('tentar criar o arquivo');
     readkey;
     ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
   end else
   if (refInformacao = 'ERRO_ABRIR_ARQUIVO') then
   begin
     posCol := 52; posLin := 3;
     DesenhaPainel(posCol, posLin, 25, 7, 'Erro');
     ExibeInformacao('PAINEL_CONFIRMACAO');
     textcolor(black); textbackground(COR_PAINEL);
     gotoxy(posCol + 1, posLin + 2);
     write('Ocorreu um problema ao');
     gotoxy(posCol + 1, posLin + 3);
     write('tentar abrir o arquivo.');
     gotoxy(posCol + 1, posLin + 4);
     write('Talvez o arquivo nao');
     gotoxy(posCol + 1, posLin + 5);
     write('exista.');
     readkey;
     ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
   end else
   if (refInformacao = 'ERRO_ABRIR_ARQUIVO_TXT_UNICODE') then
   begin
     posCol := 46; posLin := 3;
     DesenhaPainel(posCol, posLin, 31, 5, 'Erro');
     ExibeInformacao('PAINEL_CONFIRMACAO');
     textcolor(black); textbackground(COR_PAINEL);
     gotoxy(posCol + 1, posLin + 2);
     write('O PaintZim20 nao decodifica');
     gotoxy(posCol + 1, posLin + 3);
     write('arquivos de texto UNICODE');
     readkey;
     ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
   end else
   if (refInformacao = 'PAINEL_SOBRE') then
   begin
     posCol := 17; posLin := 7;
     DesenhaPainel(posCol, posLin, 46, 10, 'Sobre o PaintZim20');
     ExibeInformacao('PAINEL_BOM_AVISO');
     textcolor(black); textbackground(COR_PAINEL);
     gotoxy(posCol + 1, posLin + 2);
     write('Esta e uma ferramenta para programadores :-)');
     gotoxy(posCol + 1, posLin + 3);
     write('Explore seu potencial!');
     gotoxy(posCol + 1, posLin + 5);
     write('Autor: GRSa');
     gotoxy(posCol + 1, posLin + 8);
     write('Construido em agosto de 2013');
     readkey;
     ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
   end else
   if (refInformacao = 'PAINEL_AJUDA') then
   begin
     posCol := 14; posLin := 3;
     DesenhaPainel(posCol, posLin, 52, 20, 'Ajuda');
     gotoxy(posCol + 1, posLin + 2);
     write('Setas          - Mover cursor');
     gotoxy(posCol + 1, posLin + 3);
     write('Ctrl+Setas     - Mover tela');
     gotoxy(posCol + 1, posLin + 4);
     write('Ctrl+Enter     - Iniciar selecao');
     gotoxy(posCol + 1, posLin + 5);
     write('Ctrl+Alt+Enter - Inserir somente cor');
     gotoxy(posCol + 1, posLin + 6);
     write('Ctrl+Z         - Desfazer');
     gotoxy(posCol + 1, posLin + 7);
     write('Ctrl+R         - Refazer');
     gotoxy(posCol + 1, posLin + 8);
     write('Ctrl+L         - Capturar caractere sob o cursor');
     gotoxy(posCol + 1, posLin + 9);
     write('Ctrl+V         - Colar (para Copiar use a selecao)');
     gotoxy(posCol + 1, posLin + 11);
     write('F4             - Alterar modo de insercao');
     gotoxy(posCol + 1, posLin + 12);
     write('F5             - Alterar caractere atual');
     gotoxy(posCol + 1, posLin + 13);
     write('F6             - Importar TXT');
     gotoxy(posCol + 1, posLin + 14);
     write('F9             - Alterar cores do caractere');
     gotoxy(posCol + 1, posLin + 15);
     write('F10            - Alterar cor da pagina');
     gotoxy(posCol + 1, posLin + 16);
     write('F12            - Alterar atalhos');
     gotoxy(posCol + 1, posLin + 18);
     write('Outras opcoes estarao facilmente visiveis');
     ExibeInformacao('PAINEL_CONFIRMACAO');
     readkey;
     ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
   end else
   if (refInformacao = 'PAINEL_??') then
   begin

   end;
 End;

 {----------------------------------------------------
     Procedure MostraCursor;
  -----------------------------------------------------}
 Procedure MostraCursor(mostra : boolean);
 Begin

   cursor.formato.corFundo := matriz.pagina[definicao.refColPagina - 1 + cursor.posCol, definicao.refLinPagina - 1 + cursor.posLin].corFundo;

   if matriz.pagina[definicao.refColPagina - 1 + cursor.posCol, definicao.refLinPagina - 1 + cursor.posLin].cor = 15 then
   cursor.formato.cor := 16
   else
   cursor.formato.cor := 15;

   cursor.formato.caractere := 176;

   if mostra then //Desenha o cursor na tela
   begin
     textcolor(cursor.formato.cor); textbackground(cursor.formato.corFundo);
     gotoxy(POSICAO_COL_TELA - 1 + cursor.posCol, POSICAO_LIN_TELA - 1 + cursor.posLin); write(chr(cursor.formato.caractere));
   end else
   begin
     textcolor(matriz.pagina[definicao.refColPagina - 1 + cursor.posCol, definicao.refLinPagina - 1 + cursor.posLin].cor);
     textbackground(matriz.pagina[definicao.refColPagina - 1 + cursor.posCol, definicao.refLinPagina - 1 + cursor.posLin].corFundo);
     gotoxy(POSICAO_COL_TELA - 1 + cursor.posCol, POSICAO_LIN_TELA - 1 + cursor.posLin);
     write(chr(matriz.pagina[definicao.refColPagina - 1 + cursor.posCol, definicao.refLinPagina - 1 + cursor.posLin].caractere));
   end;

 End;

 {----------------------------------------------------
     Procedure ExibeLimitesSelecao;
  -----------------------------------------------------}
 Procedure ExibeLimitesSelecao (posCol, posLin, dimCol, dimLin : integer;
                                mostra : boolean);
 Const
 CARAC_NO = #43;
 CARAC_NE = #43;
 CARAC_SO = #43;
 Var
 aux, posColExtremidade, posLinExtremidade : integer;
 refColCursor, refLinCursor : integer;
 caractereExtremidade : char;
 Begin

   refColCursor := definicao.refColPagina + cursor.posCol - 1;
   refLinCursor := definicao.refLinPagina + cursor.posLin - 1;

   for aux := 1 to 3 do
   begin

     case(aux) of
       1: begin  //NOROESTE
            posColExtremidade := posCol;
            posLinExtremidade := posLin;
            if mostra then
            caractereExtremidade := CARAC_NO;
          end;
       2: begin //NORDESTE
            if refColCursor >= selecao.posCol then
            posColExtremidade := posCol + dimCol - 1
            else
            posColExtremidade := posCol - dimCol + 1;

            posLinExtremidade := posLin;

            if mostra then
            caractereExtremidade := CARAC_NE;
          end;
       3: begin //SUDOESTE
            posColExtremidade := posCol;

            if refLinCursor >= selecao.posLin then
            posLinExtremidade := posLin + dimLin - 1
            else
            posLinExtremidade := posLin - dimLin + 1;

            if mostra then
            caractereExtremidade := CARAC_SO;
          end;
     end;


     if (posColExtremidade >= definicao.refColPagina) and
        (posColExtremidade <= definicao.refColPagina + DIMENSAO_COL_TELA - 1) and
        (posLinExtremidade >= definicao.refLinPagina) and
        (posLinExtremidade <= definicao.refLinPagina + DIMENSAO_LIN_TELA - 1) then
     begin

       if mostra then
       begin
         if editor.temporizador = 1 then
         begin
           if matriz.pagina[posColExtremidade, posLinExtremidade].cor = 15 then
           textcolor(16)
           else
           textcolor(15);
           textbackground(matriz.pagina[posColExtremidade, posLinExtremidade].corFundo);
           gotoxy(posColExtremidade - definicao.refColPagina + 1 + POSICAO_COL_TELA - 1,
                  posLinExtremidade - definicao.refLinPagina + 1 + POSICAO_LIN_TELA - 1);
           write(caractereExtremidade);
         end else
         if editor.temporizador = TEMPO_MAX_TEMPORIZADOR div 2 + 1 then
         begin
           caractereExtremidade := chr(matriz.pagina[posColExtremidade, posLinExtremidade].caractere);
           textcolor(matriz.pagina[posColExtremidade, posLinExtremidade].cor);
           textbackground(matriz.pagina[posColExtremidade, posLinExtremidade].corFundo);
           gotoxy(posColExtremidade - definicao.refColPagina + 1 + POSICAO_COL_TELA - 1,
                  posLinExtremidade - definicao.refLinPagina + 1 + POSICAO_LIN_TELA - 1);
           write(caractereExtremidade);
         end;
       end else
       begin
         caractereExtremidade := chr(matriz.pagina[posColExtremidade, posLinExtremidade].caractere);
         textcolor(matriz.pagina[posColExtremidade, posLinExtremidade].cor);
         textbackground(matriz.pagina[posColExtremidade, posLinExtremidade].corFundo);
         gotoxy(posColExtremidade - definicao.refColPagina + 1 + POSICAO_COL_TELA - 1,
                posLinExtremidade - definicao.refLinPagina + 1 + POSICAO_LIN_TELA - 1);
         write(caractereExtremidade);
       end;

     end;

   end;
 End;  

 {----------------------------------------------------
     Procedure InicializaDefinicoes;
  -----------------------------------------------------}
 Procedure InicializaDefinicoes;
 Var
 auxIntA, auxIntB : integer;
 Begin

   cursorOff;

   textbackground(7); clrscr;

   editor.caractere := 219;
   editor.corCaractere := 14;
   editor.corFundoCaractere := 3;
   editor.corFundo := 3;
   editor.temporizador := 0;

   editor.modoContinuo := false;
   editor.arquivoAberto := false;
   editor.modoAtalho := false;

   editor.refGrupoPredefinido := 1;

   editor.grupoPredefinido[0] := 176;
   editor.grupoPredefinido[1] := 177;
   editor.grupoPredefinido[2] := 178;
   editor.grupoPredefinido[3] := 219;
   editor.grupoPredefinido[4] := 220;
   editor.grupoPredefinido[5] := 223;
   editor.grupoPredefinido[6] := 254;
   editor.grupoPredefinido[7] := 22;
   editor.grupoPredefinido[8] := 46;
   editor.grupoPredefinido[9] := 250;

   historico.quantElementosDesfazer := 0;
   historico.quantElementosRefazer := 0;
   historico.refListaDesfazer := 0;
   historico.refListaRefazer := 0;
   historico.refCicloDesfazer := 0;
   historico.refCicloRefazer := 0;

   historico.trocarCiclo := true;

   selecao.ativa := false;

   areaTransferencia.quantElementos := 0;

   for auxIntA := 1 to DIMENSAO_COL_PAGINA do
   begin
     for auxIntB := 1 to DIMENSAO_LIN_PAGINA do
     begin
       matriz.pagina[auxIntA, auxIntB].caractere := CARACTERE_NULO;
       matriz.pagina[auxIntA, auxIntB].cor := editor.corFundo;
       matriz.pagina[auxIntA, auxIntB].corFundo := editor.corFundo;
     end;
   end;

   for auxIntA := 1 to DIMENSAO_COL_TELA do
   begin
     for auxIntB := 1 to DIMENSAO_LIN_TELA do
     begin
       matriz.tela[auxIntA, auxIntB].caractere := CARACTERE_NULO;
       matriz.tela[auxIntA, auxIntB].cor := editor.corFundo;
       matriz.tela[auxIntA, auxIntB].corFundo := editor.corFundo;
     end;
   end;

   {randomize;
   for auxIntA := 10 to 50 do
   begin
     for auxIntB := 10 to 50 do
     begin
       matriz.pagina[auxIntA, auxIntB].caractere := random(5) + 50;
       matriz.pagina[auxIntA, auxIntB].cor := random(16) + 1;
       matriz.pagina[auxIntA, auxIntB].corFundo := random(16) + 1;
     end;
   end;}

   definicao.refColPagina := 1;
   definicao.refLinPagina := 1;
   definicao.finalizarPrograma := false;

   ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);

   cursor.posCol := 2;
   cursor.posLin := 2;

   MostraCursor(true);

   ExibeInformacao('PAINEL_PADRAO');
   ExibeInformacao('PAINEL_CABECALHO_1');
   ExibeInformacao('PAINEL_STATUS');

 End;

 {----------------------------------------------------
     Procedure IncrementaHistoricoDesfazer;
  -----------------------------------------------------}
 Procedure IncrementaHistoricoDesfazer (elemento : ElementoImagem;
                                        posCol, posLin : integer;
                                        trocarCiclo : boolean);
 Begin

   if historico.quantElementosDesfazer < DIMENSAO_HISTORICO div 2 then
   inc(historico.quantElementosDesfazer);

   if historico.quantElementosDesfazer = 1 then
   historico.refCicloDesfazer := 1 else
   if trocarCiclo then
   inc(historico.refCicloDesfazer);

   inc(historico.refListaDesfazer);
   if historico.refListaDesfazer > DIMENSAO_HISTORICO div 2 then
   historico.refListaDesfazer := 1;

   historico.lista[historico.refListaDesfazer].elemento := elemento;
   historico.lista[historico.refListaDesfazer].posCol := posCol;
   historico.lista[historico.refListaDesfazer].posLin := posLin;
   historico.lista[historico.refListaDesfazer].ciclo := historico.refCicloDesfazer;

 End;

 {----------------------------------------------------
     Procedure IncrementaHistoricoRefazer;
  -----------------------------------------------------}
 Procedure IncrementaHistoricoRefazer (elemento : ElementoImagem;
                                       posCol, posLin : integer);
 Begin

   if historico.quantElementosRefazer < DIMENSAO_HISTORICO div 2 then
   inc(historico.quantElementosRefazer);

   if historico.quantElementosRefazer = 1 then
   historico.refCicloRefazer := 1;

   inc(historico.refListaRefazer);
   if historico.refListaRefazer > DIMENSAO_HISTORICO div 2 then
   historico.refListaRefazer := 1;

   historico.lista[historico.refListaRefazer + DIMENSAO_HISTORICO div 2].elemento := elemento;
   historico.lista[historico.refListaRefazer + DIMENSAO_HISTORICO div 2].posCol := posCol;
   historico.lista[historico.refListaRefazer + DIMENSAO_HISTORICO div 2].posLin := posLin;
   historico.lista[historico.refListaRefazer + DIMENSAO_HISTORICO div 2].ciclo := historico.refCicloRefazer;

 End;

 {----------------------------------------------------
     Procedure DesfazUltimaAcao;
  -----------------------------------------------------}
 Procedure DesfazUltimaAcao;
 Var
 posLista, refCiclo, posCol, posLin : integer;
 Begin

   {historico.trocarCiclo := true;}

   if historico.quantElementosDesfazer > 0 then
   begin

     posLista := historico.refListaDesfazer;
     refCiclo := historico.refCicloDesfazer;

     inc(historico.refCicloRefazer);

     while(true) do
     begin

       if (historico.lista[posLista].ciclo = refCiclo) and
          (historico.quantElementosDesfazer > 0) then
       begin

         posCol := historico.lista[posLista].posCol;
         posLin := historico.lista[posLista].posLin;

         IncrementaHistoricoRefazer(matriz.pagina[posCol, posLin],
                                    posCol,
                                    posLin);

         if historico.lista[posLista].elemento.caractere = CARACTERE_NULO then
         begin
           historico.lista[posLista].elemento.cor := editor.corFundo;
           historico.lista[posLista].elemento.corFundo := editor.corFundo;
         end;

         matriz.pagina[posCol, posLin] := historico.lista[posLista].elemento;

         dec(historico.quantElementosDesfazer);

         //Exibe na tela
         if (posCol >= definicao.refColPagina) and
            (posCol <= definicao.refColPagina + DIMENSAO_COL_TELA - 1) and
            (posLin >= definicao.refLinPagina) and
            (posLin <= definicao.refLinPagina + DIMENSAO_LIN_TELA - 1) then
         begin
           textcolor(matriz.pagina[posCol, posLin].cor);
           textbackground(matriz.pagina[posCol, posLin].corFundo);
           gotoxy(posCol - definicao.refColPagina + 1 + POSICAO_COL_TELA - 1,
                  posLin - definicao.refLinPagina + 1 + POSICAO_LIN_TELA - 1);
           write(chr(matriz.pagina[posCol, posLin].caractere));
         end;

         if posLista > 1 then
         begin

           dec(posLista);
           dec(historico.refListaDesfazer);

         end else
         begin
           posLista := DIMENSAO_HISTORICO div 2;
           historico.refListaDesfazer := DIMENSAO_HISTORICO div 2;
         end;

       end else
       begin
         //ExibeTela(definicao.refColPagina, definicao.refLinPagina);
         MostraCursor(true);
         if historico.quantElementosDesfazer > 0 then
         historico.refCicloDesfazer := historico.lista[posLista].ciclo
         else
         begin
           historico.refListaDesfazer := 0;
           historico.refCicloDesfazer := 0;
         end;
         break;
       end;

     end;

   end;

 End;

 {----------------------------------------------------
     Procedure RefazUltimaAcao;
  -----------------------------------------------------}
 Procedure RefazUltimaAcao;
 Var
 posLista, refCiclo, posCol, posLin : integer;
 Begin

   if historico.quantElementosRefazer > 0 then
   begin

     posLista := historico.refListaRefazer;
     refCiclo := historico.refCicloRefazer;

     historico.trocarCiclo := true;

     while(true) do
     begin

       if (historico.lista[posLista + DIMENSAO_HISTORICO div 2].ciclo = refCiclo) and
          (historico.quantElementosRefazer > 0) then
       begin

         posCol := historico.lista[posLista + DIMENSAO_HISTORICO div 2].posCol;
         posLin := historico.lista[posLista + DIMENSAO_HISTORICO div 2].posLin;

         IncrementaHistoricoDesfazer(matriz.pagina[posCol, posLin],
                                     posCol,
                                     posLin, historico.trocarCiclo);

         historico.trocarCiclo := false;

         if historico.lista[posLista + DIMENSAO_HISTORICO div 2].elemento.caractere = CARACTERE_NULO then
         begin
           historico.lista[posLista + DIMENSAO_HISTORICO div 2].elemento.cor := editor.corFundo;
           historico.lista[posLista + DIMENSAO_HISTORICO div 2].elemento.corFundo := editor.corFundo;
         end;

         matriz.pagina[posCol, posLin] := historico.lista[posLista + DIMENSAO_HISTORICO div 2].elemento;

         dec(historico.quantElementosRefazer);

         //Exibe na tela
         {if (posCol >= definicao.refColPagina) and
            (posCol <= definicao.refColPagina + DIMENSAO_COL_TELA - 1) and
            (posLin >= definicao.refLinPagina) and
            (posLin <= definicao.refLinPagina + DIMENSAO_LIN_TELA - 1) then
         begin
           textcolor(matriz.pagina[posCol, posLin].cor);
           textbackground(matriz.pagina[posCol, posLin].corFundo);
           gotoxy(posCol - definicao.refColPagina + 1 + POSICAO_COL_TELA - 1,
                  posLin - definicao.refLinPagina + 1 + POSICAO_LIN_TELA - 1);
           write(chr(matriz.pagina[posCol, posLin].caractere));
         end;}

         if posLista > 1 then
         begin

           dec(posLista);
           dec(historico.refListaRefazer);

         end else
         begin
           posLista := DIMENSAO_HISTORICO div 2;
           historico.refListaRefazer := DIMENSAO_HISTORICO div 2;
         end;

       end else
       begin
         //ExibeTela(definicao.refColPagina, definicao.refLinPagina);
         //MostraCursor(true);
         if historico.quantElementosRefazer > 0 then
         historico.refCicloRefazer := historico.lista[posLista + DIMENSAO_HISTORICO div 2].ciclo
         else
         begin
           historico.refListaRefazer := 0;
           historico.refCicloRefazer := 0;
         end;
         break;
       end;

       historico.trocarCiclo := false;

     end;

   end;

 End;

 {----------------------------------------------------
     Procedure InsereElemento;
  -----------------------------------------------------}
 Procedure InsereElemento(caractere, corCaractere, corFundoCaractere : integer;
                          posCol, posLin : integer);
 Begin

   if (posCol > 0) and (posCol <= DIMENSAO_COL_PAGINA) and
      (posLin > 0) and (posLin <= DIMENSAO_LIN_PAGINA) and
      (caractere <> 7) and (caractere <> 8) and
	  (caractere <> 10) and (caractere <> 13) then
	  
   begin
     IncrementaHistoricoDesfazer(matriz.pagina[posCol, posLin], posCol, posLin, historico.trocarCiclo);
     matriz.pagina[posCol, posLin].caractere := caractere;
     matriz.pagina[posCol, posLin].cor := corCaractere;
     matriz.pagina[posCol, posLin].corFundo := corFundoCaractere;
   end;
 End;

 {----------------------------------------------------
     Procedure RedefineFundoPagina;
  -----------------------------------------------------}
 Procedure RefineFundoPagina;
 Var
 auxIntA, auxIntB : integer;
 Begin
   for auxIntA := 1 to DIMENSAO_COL_PAGINA do
   begin
     for auxIntB := 1 to DIMENSAO_LIN_PAGINA do
     begin
       if matriz.pagina[auxIntA, auxIntB].caractere = 255 then
       begin
         matriz.pagina[auxIntA, auxIntB].cor := editor.corFundo;
         matriz.pagina[auxIntA, auxIntB].corFundo := editor.corFundo;
       end;
     end;
   end;
 End;

 {----------------------------------------------------
     Procedure SelecionaCaractere;
  -----------------------------------------------------}
 Procedure SelecionaCaractere;
 Const
 POSICAO_COL_PAINEL = 7;
 POSICAO_LIN_PAINEL = 3;
 COR_SELECAO = 15;
 COR_FUNDO_SELECAO = 1;
 Var
 tecla : string;
 auxA, auxB, posColSelecao, posLinSelecao : integer;
 caractere : integer;

   Function CaractereEspecial(carac : integer) : boolean;
   Begin
     if (carac = 0) or
        (carac = 7) or
        (carac = 8) or
        (carac = 10) or
        (carac = 13) or
        (carac = 255) then
     CaractereEspecial := true
     else
     CaractereEspecial := false;
   End;

   Procedure ExibeSelecao(mostra : boolean);
   {Subrotina da rotina SelecionaCaractere}
   Var
   carac : integer;
   Begin
     carac := 32 * (posLinSelecao - 1) + posColSelecao - 1;
     if mostra then
     begin
       gotoxy(POSICAO_COL_PAINEL + 2 + (posColSelecao * 2 - 2),
              POSICAO_LIN_PAINEL + 2 + (posLinSelecao * 2 - 2));
       textcolor(COR_SELECAO); textbackground(COR_FUNDO_SELECAO);
       if CaractereEspecial(carac) then
       write(chr(CARACTERE_NULO)) else
       write(chr(carac));
     end else
     begin
       gotoxy(POSICAO_COL_PAINEL + 2 + (posColSelecao * 2 - 2),
              POSICAO_LIN_PAINEL + 2 + (posLinSelecao * 2 - 2));
       textcolor(black); textbackground(COR_PAINEL);
       if CaractereEspecial(carac) then
       write(chr(CARACTERE_NULO)) else
       write(chr(carac));
     end;
   End;

 Begin

   DesenhaPainel(POSICAO_COL_PAINEL, POSICAO_LIN_PAINEL, 67, 20, 'Caracteres');

   for auxA := 1 to 8 do
   for auxB := 0 to 31 do
   begin
     caractere := (32 * (auxA - 1)) + auxB;
     if not(CaractereEspecial(caractere)) then
     begin
       gotoxy(POSICAO_COL_PAINEL + 3 + ((auxB * 2) - 1), POSICAO_LIN_PAINEL + ((auxA * 2)));
       write(chr(caractere));
     end;
   end;

   if editor.caractere <= 31 then
   posLinSelecao := 1
   else
   if editor.caractere <= 63 then
   posLinSelecao := 2
   else
   if editor.caractere <= 95 then
   posLinSelecao := 3
   else
   if editor.caractere <= 127 then
   posLinSelecao := 4
   else
   if editor.caractere <= 159 then
   posLinSelecao := 5
   else
   if editor.caractere <= 191 then
   posLinSelecao := 6
   else
   if editor.caractere <= 223 then
   posLinSelecao := 7
   else
   posLinSelecao := 8;

   posColSelecao := editor.caractere - (32 * (posLinSelecao - 1)) + 1;
   caractere := (32 * (posLinSelecao - 1) + posColSelecao - 1);

   ExibeSelecao(true);

   gotoxy(POSICAO_COL_PAINEL + 2, POSICAO_LIN_PAINEL + 18);
   textcolor(16); textbackground(7); write(caractere, '     ');

   while (true) do
   begin
     delay(10);
     tecla := ObtemTeclaPressionada;
     if (tecla <> NULO) then
     begin
       if (tecla = TECLA_UP) then
       begin
         ExibeSelecao(false);
         dec(posLinSelecao);
         if posLinSelecao = 0 then
         posLinSelecao := 8;
       end else
       if (tecla = TECLA_DOWN) then
       begin
         ExibeSelecao(false);
         inc(posLinSelecao);
         if posLinSelecao = 9 then
         posLinSelecao := 1;
       end else
       if (tecla = TECLA_RIGHT) then
       begin
         ExibeSelecao(false);
         inc(posColSelecao);
         if posColSelecao = 33 then
         posColSelecao := 1;
       end else
       if (tecla = TECLA_LEFT) then
       begin
         ExibeSelecao(false);
         dec(posColSelecao);
         if posColSelecao = 0 then
         posColSelecao := 32;
       end else
       if (tecla = TECLA_ENTER) then
       begin
         caractere := (32 * (posLinSelecao - 1) + posColSelecao - 1);
         if not(CaractereEspecial(caractere)) then
         begin
           editor.caractere := caractere;
           ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
           MostraCursor(true);
           Exit;
         end;
       end else
       if (tecla = TECLA_ESC) then
       begin
         ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
         MostraCursor(true);
         Exit;
       end;
       ExibeSelecao(true);

       caractere := (32 * (posLinSelecao - 1) + posColSelecao - 1);
       gotoxy(POSICAO_COL_PAINEL + 2, POSICAO_LIN_PAINEL + 18);
       if CaractereEspecial(caractere) then
       textcolor(lightred) else textcolor(16);
       textbackground(7);
       write(caractere, '     ');
     end;
   end;

 End;

 {----------------------------------------------------
     Procedure SelecionaCor;
  -----------------------------------------------------}
 Procedure SelecionaCor(elemento : string);
   Const
     POSICAO_COL_PAINEL = POSICAO_COL_TELA + 66;
     POSICAO_LIN_PAINEL = POSICAO_LIN_TELA + 1;
   Var
   corCaractere, corFundoCaractere, corPagina,
   nivel, aux : integer;
   tecla : string;

   Procedure ExibePrevisualizacao;
   Begin
     gotoxy(POSICAO_COL_TELA + 64, POSICAO_LIN_TELA + DIMENSAO_LIN_TELA);
     textcolor(corCaractere); textbackground(corFundoCaractere);
     write('Previsualizacao');
   End;

   Procedure DesenhaSetas;
   Begin
     DesenhaRetangulo(POSICAO_COL_PAINEL + 1, POSICAO_LIN_PAINEL + 2, 8, 1, COR_PAINEL);
     DesenhaRetangulo(POSICAO_COL_PAINEL + 1, POSICAO_LIN_PAINEL + 5, 8, 1, COR_PAINEL);
     DesenhaRetangulo(POSICAO_COL_PAINEL + 1, POSICAO_LIN_PAINEL + 6, 8, 1, COR_PAINEL);

     if (upcase(elemento) = 'CARACTERE') then
     begin
       textbackground(COR_PAINEL);
       if (nivel = 1) then
       textcolor(black) else textcolor(8);
       if corCaractere > 8 then
       begin
         gotoxy(POSICAO_COL_PAINEL + corCaractere - 8, POSICAO_LIN_PAINEL + 2);
         write(#31);
       end else
       begin
         gotoxy(POSICAO_COL_PAINEL + corCaractere, POSICAO_LIN_PAINEL + 5);
         write(#30);
       end;
       if (nivel = 2) then
       textcolor(black) else textcolor(8);
       gotoxy(POSICAO_COL_PAINEL + corFundoCaractere, POSICAO_LIN_PAINEL + 6);
       write(#31);
     end else
     begin
       gotoxy(POSICAO_COL_PAINEL + corPagina, POSICAO_LIN_PAINEL + 5);
       textbackground(COR_PAINEL); textcolor(black); write(#30);
     end;
   End;

 Begin
   DesenhaPainel(POSICAO_COL_PAINEL, POSICAO_LIN_PAINEL, 10, 9, 'Cores');
   for aux := 1 to 8 do {Desenha a paleta de cores}
   begin
     if (upcase(elemento) = 'CARACTERE') then
     begin
       gotoxy(POSICAO_COL_PAINEL + aux, POSICAO_LIN_PAINEL + 3);
       textcolor(aux + 8); write(#219);
       gotoxy(POSICAO_COL_PAINEL + aux, POSICAO_LIN_PAINEL + 4);
       textcolor(aux);
       write(#219);
       gotoxy(POSICAO_COL_PAINEL + aux, POSICAO_LIN_PAINEL + 7);
       if (aux = 8) then textcolor(16) else textcolor(aux);
       write(#219);
     end else
     begin
       gotoxy(POSICAO_COL_PAINEL + aux, POSICAO_LIN_PAINEL + 3);
       if (aux = 8) then textcolor(16) else textcolor(aux);
       write(#219);
       gotoxy(POSICAO_COL_PAINEL + aux, POSICAO_LIN_PAINEL + 4);
       write(#219);
     end;
   end;

   corCaractere := editor.corCaractere;
   corFundoCaractere := editor.corFundoCaractere;
   corPagina := editor.corFundo;

   if (upcase(elemento) = 'CARACTERE') then
   nivel := 1 else nivel := 2;

   DesenhaSetas;

   if (upcase(elemento) = 'CARACTERE') then
   ExibePrevisualizacao;

   while (true) do
   begin
     delay(10);
     tecla := ObtemTeclaPressionada;
     if (tecla <> NULO) then
     begin
       if (tecla = TECLA_UP) and
          (upcase(elemento) = 'CARACTERE') then
       begin
         if (nivel = 2) then
         nivel := 1 else
         begin
           if (corCaractere > 8) then
           nivel := 2 else corCaractere := corCaractere + 8;
         end;
       end else
       if (tecla = TECLA_DOWN) and
          (upcase(elemento) = 'CARACTERE') then
       begin
         if (nivel = 2) then
         nivel := 1 else
         begin
           if (corCaractere > 8) then
           corCaractere := corCaractere - 8 else nivel := 2;
         end;
       end else
       if (tecla = TECLA_RIGHT) then
       begin
         if (upcase(elemento) = 'CARACTERE') then
         begin
           if (nivel = 2) then
           begin
             if (corFundoCaractere < 8) then
             inc(corFundoCaractere) else corFundoCaractere := 1;
           end else
           begin
             if (corCaractere < 16) then
             inc(corCaractere) else corCaractere := 1;
           end;
         end else
         begin
           if (corPagina < 8) then
           inc(corPagina) else corPagina := 1;
         end;
       end else
       if (tecla = TECLA_LEFT) then
       begin
         if (upcase(elemento) = 'CARACTERE') then
         begin
           if (nivel = 2) then
           begin
             if (corFundoCaractere > 1) then
             dec(corFundoCaractere) else corFundoCaractere := 8;
           end else
           begin
             if (corCaractere > 1) then
             dec(corCaractere) else corCaractere := 16;
           end;
         end else
         begin
           if (corPagina > 1) then
           dec(corPagina) else corPagina := 8;
         end;
       end else
       if (tecla = TECLA_TAB) then
       begin
         if (upcase(elemento) = 'CARACTERE') then
         begin
           if (nivel = 1) then
           nivel := 2 else
           nivel := 1;
         end;
       end else
       if (tecla = TECLA_ENTER) then
       begin
         if (upcase(elemento) = 'CARACTERE') then
         begin
           editor.corCaractere := corCaractere;
           editor.corFundoCaractere := corFundoCaractere;
         end else
         begin
           editor.corFundo := corPagina;
           RefineFundoPagina;
         end;
         ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
         MostraCursor(true);
         Exit;
       end else
       if (tecla = TECLA_ESC) then
       begin
         ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
         MostraCursor(true);
         Exit;
       end;

       if (upcase(elemento) = 'CARACTERE') then
       ExibePrevisualizacao;

       DesenhaSetas;
     end;
   end;

 End;

 {----------------------------------------------------
     Procedure DefineAtalhos;
  -----------------------------------------------------}
 Procedure DefineAtalhos(refGrupoAtalho : integer);
 Begin
   case (refGrupoAtalho) of
     1: begin //Retangulos
          editor.refGrupoPredefinido := 1;
          editor.grupoPredefinido[0] := 176; editor.grupoPredefinido[1] := 177;
          editor.grupoPredefinido[2] := 178; editor.grupoPredefinido[3] := 219;
          editor.grupoPredefinido[4] := 220; editor.grupoPredefinido[5] := 223;
          editor.grupoPredefinido[6] := 254; editor.grupoPredefinido[7] := 22;
          editor.grupoPredefinido[8] := 46;  editor.grupoPredefinido[9] := 250;
        end;
     2: begin //Retas
          editor.refGrupoPredefinido := 2;
          editor.grupoPredefinido[0] := 179; editor.grupoPredefinido[1] := 186;
          editor.grupoPredefinido[2] := 47; editor.grupoPredefinido[3] := 92;
          editor.grupoPredefinido[4] := 95; editor.grupoPredefinido[5] := 196;
          editor.grupoPredefinido[6] := 205; editor.grupoPredefinido[7] := 45;
          editor.grupoPredefinido[8] := 240;  editor.grupoPredefinido[9] := 238;
        end;
     3: begin //Conectores simples
          editor.refGrupoPredefinido := 3;
          editor.grupoPredefinido[0] := 218; editor.grupoPredefinido[1] := 191;
          editor.grupoPredefinido[2] := 192; editor.grupoPredefinido[3] := 217;
          editor.grupoPredefinido[4] := 194; editor.grupoPredefinido[5] := 193;
          editor.grupoPredefinido[6] := 195; editor.grupoPredefinido[7] := 180;
          editor.grupoPredefinido[8] := 197;  editor.grupoPredefinido[9] := 197;
        end;
     4: begin //Conectores duplos
          editor.refGrupoPredefinido := 4;
          editor.grupoPredefinido[0] := 201; editor.grupoPredefinido[1] := 187;
          editor.grupoPredefinido[2] := 200; editor.grupoPredefinido[3] := 188;
          editor.grupoPredefinido[4] := 203; editor.grupoPredefinido[5] := 202;
          editor.grupoPredefinido[6] := 204; editor.grupoPredefinido[7] := 185;
          editor.grupoPredefinido[8] := 206;  editor.grupoPredefinido[9] := 206;
        end;
     5: begin //Setas
          editor.refGrupoPredefinido := 5;
          editor.grupoPredefinido[0] := 25; editor.grupoPredefinido[1] := 24;
          editor.grupoPredefinido[2] := 27; editor.grupoPredefinido[3] := 26;
          editor.grupoPredefinido[4] := 18; editor.grupoPredefinido[5] := 29;
          editor.grupoPredefinido[6] := 31; editor.grupoPredefinido[7] := 30;
          editor.grupoPredefinido[8] := 17;  editor.grupoPredefinido[9] := 16;
        end;
   end;
 End;

 {----------------------------------------------------
     Procedure GerenciaSelecao;
  -----------------------------------------------------}
 Procedure GerenciaSelecao;
 Var
 refColCursor, refLinCursor : integer;
 Begin

   refColCursor := definicao.refColPagina + cursor.posCol - 1;
   refLinCursor := definicao.refLinPagina + cursor.posLin - 1;

   if (selecao.posCol < refColCursor) then
   selecao.dimCol := refColCursor - selecao.posCol + 1
   else
   if (selecao.posCol > refColCursor) then
   selecao.dimCol := selecao.posCol - refColCursor + 1
   else
   if (selecao.posCol = refColCursor) then
   selecao.dimCol := 1;

   if (selecao.posLin < refLinCursor) then
   selecao.dimLin := refLinCursor - selecao.posLin + 1
   else
   if (selecao.posLin > refLinCursor) then
   selecao.dimLin := selecao.posLin - refLinCursor + 1
   else
   if (selecao.posLin = refLinCursor) then
   selecao.dimLin := 1;

 End;

 {----------------------------------------------------
     Procedure ColaSelecao;
  -----------------------------------------------------}
 Procedure ColaSelecao(exibeFundo : boolean);
 Var
 aux, refColCursor, refLinCursor : integer;
 corFundo : integer;
 Begin

   refColCursor := definicao.refColPagina + cursor.posCol - 1;
   refLinCursor := definicao.refLinPagina + cursor.posLin - 1;

   historico.trocarCiclo := true;

   for aux := 1 to areaTransferencia.quantElementos do
   begin

     if (areaTransferencia.matriz[aux].elemento.caractere <> CARACTERE_NULO) then
     begin
       if exibeFundo then
       corFundo := areaTransferencia.matriz[aux].elemento.corFundo
       else
       corFundo := matriz.pagina[refColCursor + areaTransferencia.matriz[aux].posCol - 1,
                                 refLinCursor + areaTransferencia.matriz[aux].posLin - 1].corFundo;

       InsereElemento(areaTransferencia.matriz[aux].elemento.caractere,
                      areaTransferencia.matriz[aux].elemento.cor,
                      corFundo,
                      refColCursor + areaTransferencia.matriz[aux].posCol - 1,
                      refLinCursor + areaTransferencia.matriz[aux].posLin - 1);
       historico.trocarCiclo := false;

     end;

   end;

   ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
   MostraCursor(true);
 End;

 {----------------------------------------------------
     Procedure ManipulaAreaSelecionada;
  -----------------------------------------------------}
 Procedure ManipulaAreaSelecionada(acao : string);
 Var
 colPagina, linPagina : integer;
 refColCursor, refLinCursor : integer;
 refColAreaTransferencia, refLinAreaTransferencia : integer;
 refColA, refColB, refLinA, refLinB : integer;

 Begin

   refColCursor := definicao.refColPagina + cursor.posCol - 1;
   refLinCursor := definicao.refLinPagina + cursor.posLin - 1;

   historico.trocarCiclo := true;

   if refColCursor >= selecao.posCol then
   begin
     if refLinCursor >= selecao.posLin then
     begin
       refColA := selecao.posCol;
       refColB := refColCursor;
       refLinA := selecao.posLin;
       refLinB := refLinCursor;
     end else
     begin
       refColA := selecao.posCol;
       refColB := refColCursor;
       refLinA := refLinCursor;
       refLinB := selecao.posLin;
     end;
   end else
   begin
     if refLinCursor >= selecao.posLin then
     begin
       refColA := refColCursor;
       refColB := selecao.posCol;
       refLinA := selecao.posLin;
       refLinB := refLinCursor;
     end else
     begin
       refColA := refColCursor;
       refColB := selecao.posCol;
       refLinA := refLinCursor;
       refLinB := selecao.posLin;
     end;
   end;

   if (upcase(acao) = 'COPIAR') then
   begin

     if selecao.dimCol * selecao.dimLin > DIMENSAO_AREA_TRANSFERENCIA then
     {Não realiza o armazenamento da seleção na área de transferência caso
      a quantidade de dados exceda o máximo suportado}
     Exit;

     areaTransferencia.quantElementos := 0;

     refColAreaTransferencia := 0;
     refLinAreaTransferencia := 0;

     for colPagina := refColA to refColB do
     begin
       inc(refColAreaTransferencia);
       refLinAreaTransferencia := 0;
       for linPagina := refLinA to refLinB do
       begin
         inc(areaTransferencia.quantElementos);
         inc(refLinAreaTransferencia);
         areaTransferencia.matriz[areaTransferencia.quantElementos].elemento := matriz.pagina[colPagina, linPagina];
         areaTransferencia.matriz[areaTransferencia.quantElementos].posCol := refColAreaTransferencia;
         areaTransferencia.matriz[areaTransferencia.quantElementos].posLin := refLinAreaTransferencia;
       end;
     end;
   end else
   if (upcase(acao) = 'PREENCHER') then
   begin
     for colPagina := refColA to refColB do
     for linPagina := refLinA to refLinB do
     begin
       InsereElemento(editor.caractere, editor.corCaractere, editor.corFundoCaractere,
                      colPagina, linPagina);
       historico.trocarCiclo := false;
     end;
   end else
   if (upcase(acao) = 'COLORIR_CARACTERE') then
   begin
     for colPagina := refColA to refColB do
     for linPagina := refLinA to refLinB do
     begin
       if matriz.pagina[colPagina, linPagina].caractere <> CARACTERE_NULO then
       begin
         InsereElemento(matriz.pagina[colPagina, linPagina].caractere, editor.corCaractere,
                        matriz.pagina[colPagina, linPagina].corFundo,
                        colPagina, linPagina);
         historico.trocarCiclo := false;
       end;
     end;
   end else
   if (upcase(acao) = 'COLORIR_FUNDO_CARACTERE') then
   begin
     for colPagina := refColA to refColB do
     for linPagina := refLinA to refLinB do
     begin
       if matriz.pagina[colPagina, linPagina].caractere <> CARACTERE_NULO then
       begin
         InsereElemento(matriz.pagina[colPagina, linPagina].caractere,
                        matriz.pagina[colPagina, linPagina].cor, editor.corFundoCaractere,
                        colPagina, linPagina);
         historico.trocarCiclo := false;
       end;
     end;
   end else
   if (upcase(acao) = 'APAGAR') then
   begin
     for colPagina := refColA to refColB do
     for linPagina := refLinA to refLinB do
     begin
       if matriz.pagina[colPagina, linPagina].caractere <> CARACTERE_NULO then
       begin
         InsereElemento(CARACTERE_NULO,
                        editor.corFundo, editor.corFundo,
                        colPagina, linPagina);
         historico.trocarCiclo := false;
       end;
     end;
   end else
   if (upcase(acao) = 'COLORIR_CARACTERE_ATUAL') then
   begin
     for colPagina := refColA to refColB do
     for linPagina := refLinA to refLinB do
     begin
       if matriz.pagina[colPagina, linPagina].caractere <> CARACTERE_NULO then
       begin
         if (matriz.pagina[colPagina, linPagina].caractere = editor.caractere) then
         begin
           InsereElemento(matriz.pagina[colPagina, linPagina].caractere,
                          editor.corCaractere, editor.corFundoCaractere,
                          colPagina, linPagina);
           historico.trocarCiclo := false;
         end;
       end;
     end;
   end;


 End;

 {----------------------------------------------------
     Function RetornaReferencia;
  -----------------------------------------------------}
 Function RetornaReferencia (ref : integer) : String;
 {Rebece a referência a um caractere ASCII a retorna como string
  ajustado para três dígitos}
 Var
 saida : string;
 Begin
   //if (ref < 0) then //Ajusta possíveis erros de compilação do Pascalzim
   //ref := 256 + ref;
   str(ref, saida);
   if (length(saida) < 3) then
   begin
     case length(saida) of
       1: saida := concat('00', saida);
       2: saida := concat('0', saida);
     end;
   end;
   RetornaReferencia := saida;
 end;

 {----------------------------------------------------
     Function SalvaArquivoPaintZim20;
  -----------------------------------------------------}
 Function SalvaArquivoPaintZim20(nomeArquivo : string) : boolean;
 Var
 arq : text;
 refCol, refLin : integer;
 refColInicio, refColFim, refLinInicio, refLinFim : integer;
 Begin

   if nomeArquivo <> NULO then
   begin
     assign(arq, concat(nomeArquivo,'.', EXT_ARQUIVO_PAINTZIM));
     {$I-} rewrite(arq); {$I+}
     if IOResult = 0 then
     begin

       refColInicio := MaxInt;
       refColFim := 0;
       refLinInicio := MaxInt;
       refLinFim := 0;

       for refCol := 1 to DIMENSAO_COL_PAGINA do
       for refLin := 1 to DIMENSAO_LIN_PAGINA do
       begin
         if matriz.pagina[refCol, refLin].caractere <> CARACTERE_NULO then
         begin
           if refCol < refColInicio then
           refColInicio := refCol;
           if refCol > refColFim then
           refColFim := refCol;
           if refLin < refLinInicio then
           refLinInicio := refLin;
           if refLin > refLinFim then
           refLinFim := refLin;
         end;
       end;

       writeln(arq, 'Arquivo PaintZim20');
       writeln(arq, RetornaReferencia(editor.corFundo),
                    RetornaReferencia(definicao.refColPagina),
                    RetornaReferencia(definicao.refLinPagina));
       writeln(arq, RetornaReferencia(refColInicio),
                    RetornaReferencia(refColFim),
                    RetornaReferencia(refLinInicio),
                    RetornaReferencia(refLinFim));

       for refCol := 1 to DIMENSAO_COL_PAGINA do
       for refLin := 1 to DIMENSAO_LIN_PAGINA do
       begin
         if (matriz.pagina[refCol, refLin].caractere <> CARACTERE_NULO) then
         begin
           writeln(arq,
                   RetornaReferencia(refCol),
                   RetornaReferencia(refLin),
                   RetornaReferencia(matriz.pagina[refCol, refLin].caractere),
                   RetornaReferencia(matriz.pagina[refCol, refLin].cor),
                   RetornaReferencia(matriz.pagina[refCol, refLin].corFundo));
         end;
       end;

       editor.arquivoAberto := true;

       editor.nomeArquivo := nomeArquivo;

       close(arq);
       SalvaArquivoPaintZim20 := true;
     end else
     begin
       SalvaArquivoPaintZim20 := false;
     end;
   end else
   SalvaArquivoPaintZim20 := true;
 End;

 {----------------------------------------------------
     Function CarregaArquivoPaintZim20;
  -----------------------------------------------------}
 Function CarregaArquivoPaintZim20(nomeArquivo : string) : boolean;
 Var
 arq : text;
 refCol, refLin : integer;
 registro, dado, aux,
 strPosC, strPosL,
 strCaractere, strCorCaractere, strCorFundoCaractere : string;
 Begin

   if nomeArquivo <> NULO then
   begin
     assign(arq, concat(nomeArquivo,'.', EXT_ARQUIVO_PAINTZIM));
     {$I-} reset(arq); {$I+}
     if IOResult = 0 then
     begin

       readln(arq, aux);
       if (aux <> 'Arquivo PaintZim20') then //Verifica versão
       begin
         CarregaArquivoPaintZim20 := false;
         close(arq);
         Exit;
       end;

       for refCol := 1 to DIMENSAO_COL_PAGINA do
       begin
         for refLin := 1 to DIMENSAO_LIN_PAGINA do
         begin
           matriz.pagina[refCol, refLin].caractere := CARACTERE_NULO;
           matriz.pagina[refCol, refLin].cor := editor.corFundo;
           matriz.pagina[refCol, refLin].corFundo := editor.corFundo;
         end;
       end;

       editor.arquivoAberto := true;
       editor.nomeArquivo := nomeArquivo;

       readln(arq, aux);
       dado := copy(aux, 1, 3); editor.corFundo := StringParaInt(dado);
       RefineFundoPagina;
       dado := copy(aux, 4, 3); definicao.refColPagina := StringParaInt(dado);
       dado := copy(aux, 7, 3); definicao.refLinPagina := StringParaInt(dado);

       readln(arq, aux);

       repeat
         readln(arq, registro);
         strPosC := copy(registro, 1, 3);
         strPosL := copy(registro, 4, 3);
         strCaractere := copy(registro, 7, 3);
         strCorCaractere := copy(registro, 10, 3);
         strCorFundoCaractere := copy(registro, 13, 3);

         InsereElemento(StringParaInt(strCaractere),
                        StringParaInt(strCorCaractere),
                        StringParaInt(strCorFundoCaractere),
                        StringParaInt(strPosC),
                        StringParaInt(strPosL));

       until(eof(arq));

       historico.quantElementosDesfazer := 0;
       historico.quantElementosRefazer := 0;
       historico.refListaDesfazer := 0;
       historico.refListaRefazer := 0;
       historico.refCicloDesfazer := 0;
       historico.refCicloRefazer := 0;

       close(arq);
       CarregaArquivoPaintZim20 := true;
     end else
     begin
       CarregaArquivoPaintZim20 := false;
     end;
   end;

 End;

 {----------------------------------------------------
     Function ExportaArquivoHTML;
  -----------------------------------------------------}
 Function ExportaArquivoHTML(nomeArquivo : string) : boolean;
 Var
 arq : text;
 ref, refCol, refLin : integer;
 cUnc : array[0..255] of String ; //Caractere Unicode
 cRGB : array[0..16] of String ; //CoresRGB
 corAnterior, corFundoAnterior : integer;
 caractere, cor, corFundo, corFundoPagina : integer;
 refColInicio, refColFim, refLinInicio, refLinFim : integer;
 cadeia : string;

 Begin

   cUnc[0]:= '&#32'; cUnc[1]:='&#9786';cUnc[2]:='&#9787';cUnc[3]:='&#9829';cUnc[4]:='&#9830';cUnc[5]:='&#9827';
   cUnc[6]:='&#9824';cUnc[7]:='&#149';cUnc[8]:='&#9689';cUnc[9]:='&#9675';cUnc[10]:='&#9689';
   cUnc[11]:='&#9794';cUnc[12]:='&#9792';cUnc[13]:='&#9834';cUnc[14]:='&#9735';cUnc[15]:='&#9788';
   cUnc[16]:='&#9658';cUnc[17]:='&#9668';cUnc[18]:='&#8597';cUnc[19]:='&#8252';cUnc[20]:='&#182';
   cUnc[21]:='&#167';cUnc[22]:='&#9644';cUnc[23]:='&#8616';cUnc[24]:='&#8593';cUnc[25]:='&#8595';
   cUnc[26]:='&#8594';cUnc[27]:='&#8592';cUnc[28]:='&#8735';cUnc[29]:='&#8596';cUnc[30]:='&#9650';
   cUnc[31]:='&#9660';
   for ref := 32 to 133 do begin str(ref, cadeia); cUnc[ref]:=concat('&#', cadeia); end;
   cUnc[127]:='&#916';cUnc[128]:='&#199';
   cUnc[129]:='&#252';cUnc[130]:='&#233';cUnc[131]:='&#226';cUnc[132]:='&#228';cUnc[133]:='&#224';
   cUnc[134]:='&#229';cUnc[135]:='&#231';
   cUnc[136]:='&#234';cUnc[137]:='&#235';cUnc[138]:='&#232';cUnc[139]:='&#239';cUnc[140]:='&#238';
   cUnc[141]:='&#236';cUnc[142]:='&#196';cUnc[143]:='&#197';cUnc[144]:='&#201';cUnc[145]:='&#230';
   cUnc[146]:='&#198';cUnc[147]:='&#244';cUnc[148]:='&#246';cUnc[149]:='&#242';cUnc[150]:='&#251';
   cUnc[151]:='&#249';cUnc[152]:='&#255';cUnc[153]:='&#214';cUnc[154]:='&#220';cUnc[155]:='&#248';
   cUnc[156]:='&#163';cUnc[157]:='&#216';cUnc[158]:='&#215';cUnc[159]:='&#131';cUnc[160]:='&#225';
   cUnc[161]:='&#237';cUnc[162]:='&#243';cUnc[163]:='&#250';cUnc[164]:='&#241';cUnc[165]:='&#209';
   cUnc[166]:='&#170';cUnc[167]:='&#186';cUnc[168]:='&#191';cUnc[169]:='&#174';cUnc[170]:='&#172';
   cUnc[171]:='&#186';cUnc[172]:='&#188';cUnc[173]:='&#161';cUnc[174]:='&#171';cUnc[175]:='&#187';
   cUnc[176]:='&#9617';cUnc[177]:='&#9618';cUnc[178]:='&#9619';cUnc[179]:='&#9474';cUnc[180]:='&#9508';
   cUnc[181]:='&#193';cUnc[182]:='&#194';cUnc[183]:='&#192';cUnc[184]:='&#169';cUnc[185]:='&#9571';
   cUnc[186]:='&#9553';cUnc[187]:='&#9559';cUnc[188]:='&#9565';cUnc[189]:='&#162';cUnc[190]:='&#165';
   cUnc[191]:='&#9488';cUnc[192]:='&#9492';cUnc[193]:='&#9524';cUnc[194]:='&#9516';cUnc[195]:='&#9500';
   cUnc[196]:='&#9472';cUnc[197]:='&#9532';cUnc[198]:='&#227';cUnc[199]:='&#195';cUnc[200]:='&#9562';
   cUnc[201]:='&#9556';cUnc[202]:='&#9577';cUnc[203]:='&#9574';cUnc[204]:='&#9568';cUnc[205]:='&#9552';
   cUnc[206]:='&#9580';cUnc[207]:='&#164';cUnc[208]:='&#240';cUnc[209]:='&#208';cUnc[210]:='&#202';
   cUnc[211]:='&#203';cUnc[212]:='&#200';cUnc[213]:='&#305';cUnc[214]:='&#205';cUnc[215]:='&#206';
   cUnc[216]:='&#207';cUnc[217]:='&#9496';cUnc[218]:='&#9484';cUnc[219]:='&#9608';cUnc[220]:='&#9604';
   cUnc[221]:='&#166';cUnc[222]:='&#204';cUnc[223]:='&#9600';cUnc[224]:='&#211';cUnc[225]:='&#223';
   cUnc[226]:='&#212';cUnc[227]:='&#210';cUnc[228]:='&#245';cUnc[229]:='&#213';cUnc[230]:='&#181';
   cUnc[231]:='&#254';cUnc[232]:='&#222';cUnc[233]:='&#218';cUnc[234]:='&#219';cUnc[235]:='&#217';
   cUnc[236]:='&#253';cUnc[237]:='&#221';cUnc[238]:='&#175';cUnc[239]:='&#180';cUnc[240]:='&#45';
   cUnc[241]:='&#177';cUnc[242]:='&#8215';cUnc[243]:='&#190';cUnc[244]:='&#182';cUnc[245]:='&#167';
   cUnc[246]:='&#247';cUnc[247]:='&#184';cUnc[248]:='&#176';cUnc[249]:='&#168';cUnc[250]:='&#183';
   cUnc[251]:='&#185';cUnc[252]:='&#179';cUnc[253]:='&#178';cUnc[254]:='&#9632';cUnc[255]:='&#32';
   ////REFERENCIA AS CORES RECONHECIDAS PELO HTML////
   cRGB[1]:='#000080';cRGB[2]:='#008000';cRGB[3]:='#008080';cRGB[4]:='#800000';
   cRGB[5]:='#800080';cRGB[6]:='#808000';cRGB[7]:='#C0C0C0';cRGB[8]:='#808080';
   cRGB[9]:='#0000FF';cRGB[10]:='#00FF00';cRGB[11]:='#00FFFF';cRGB[12]:='#FF0000';
   cRGB[13]:='#FF00FF';cRGB[14]:='#FFFF00';cRGB[15]:='#FFFFFF';cRGB[16]:='#000000';
   ////------////

   if nomeArquivo <> NULO then
   begin
      assign(arq, concat(nomeArquivo, '.', EXT_ARQUIVO_HTML));
     {$I-} rewrite(arq); {$I+}
     if IOResult = 0 then
     begin

       refColInicio := MaxInt;
       refColFim := 0;
       refLinInicio := MaxInt;
       refLinFim := 0;

       for refCol := 1 to DIMENSAO_COL_PAGINA do
       for refLin := 1 to DIMENSAO_LIN_PAGINA do
       begin
         if matriz.pagina[refCol, refLin].caractere <> CARACTERE_NULO then
         begin
           if refCol < refColInicio then
           refColInicio := refCol;
           if refCol > refColFim then
           refColFim := refCol;
           if refLin < refLinInicio then
           refLinInicio := refLin;
           if refLin > refLinFim then
           refLinFim := refLin;
         end;

       end;

       corFundoPagina := editor.corFundo;
       if corFundoPagina = 8 then
       corFundoPagina := 16;

       writeln(arq, '<!P',#225,'gina gerada pelo PaintZim20>');
       writeln(arq, '<HTML>');
       writeln(arq, '<HEAD><TITLE>', nomeArquivo, '</TITLE></HEAD>');
       writeln(arq, '<BODY BGCOLOR=',cRGB[corFundoPagina],'>');
       writeln(arq, '<PRE>');
       writeln(arq, '<FONT FACE="LUCIDA CONSOLE" SIZE=2>');

       for refLin := refLinInicio to refLinFim do
       begin
         corAnterior := 0;
         corFundoAnterior := 0;

         for refCol := refColInicio to refColFim do
         begin

           caractere := matriz.pagina[refCol, refLin].caractere;
           cor := matriz.pagina[refCol, refLin].cor;
           corFundo := matriz.pagina[refCol, refLin].corFundo;

           if (caractere = CARACTERE_NULO) and
              (cor = 8) then
           cor := 16;
           if corFundo = 8 then
           corFundo := 16;

           if (cor <> corAnterior) or
              (corFundo <> corFundoAnterior) then
           begin
             if (refCol <> refColInicio) then
             begin
               write(arq, '</B>');
             end;
             write(arq, '<B STYLE="COLOR:', cRGB[cor],'; BACKGROUND:',cRGB[corFundo],'">');
           end;

           write(arq, cUnc[caractere]);

           corAnterior := cor;
           corFundoAnterior := corFundo;

         end;

         write(arq, '</B>');
         writeln(arq);
       end;

       writeln(arq, '</FONT>');
       writeln(arq, '</PRE>');
       writeln(arq, '</BODY>');
       writeln(arq, '</HTML>');

       close(arq);
       ExportaArquivoHTML := true;
     end else
     begin
       ExportaArquivoHTML := false;
     end;
   end else
   ExportaArquivoHTML := true;
 End;

 {----------------------------------------------------
     Function ExportaCodigoPascal;
  -----------------------------------------------------}
 Function ExportaCodigoPascal(nomeArquivo : string;
                              pCPagina, pLPagina,
                              dCTrecho, dLTrecho : integer) : boolean;
 Const
 ASPASS = #39;
 Var
 arq : text;
 refCol, refLin : integer;
 caracAnterior, corAnterior, corFundoAnterior : integer;
 caractere, cor, corFundo, corFundoPagina : integer;
 refColInicio, refColFim, refLinInicio, refLinFim : integer;
 caracASCIIExtend, caracAnteriorASCIIExtend : boolean;
 refColAnterior, refLinAnterior : integer;
 posColAbsoluta, posLinAbsoluta : integer;
 primeiroCaractere : boolean;

   Procedure IniciaLinha;
   Begin
     if not(primeiroCaractere) then
     if (caracAnteriorASCIIExtend) then
     writeln(arq, ');') else
     writeln(arq, ASPASS, ');');

     if primeiroCaractere then
     primeiroCaractere := false;

     if (cor <> corAnterior) or
        (corFundo <> corFundoAnterior) then
     writeln(arq, '  textcolor(', cor, '); textbackground(', corFundo, ');'); {INSERE-SE NOVAS CORES}

     writeln(arq, '  gotoxy(', posColAbsoluta, '+posX-1, ', posLinAbsoluta, '+posY-1);');
     if caracASCIIExtend then
     write(arq, '  write(#', caractere)
     else
     write(arq, '  write(', ASPASS, chr(caractere));
   End;

 Begin
   if nomeArquivo <> NULO then
   begin
      assign(arq, concat(nomeArquivo, '.', EXT_ARQUIVO_PASCAL));
     {$I-} rewrite(arq); {$I+}
     if IOResult = 0 then
     begin

       refColInicio := MaxInt;
       refColFim := 0;
       refLinInicio := MaxInt;
       refLinFim := 0;

       for refCol := pCPagina to dCTrecho do
       for refLin := pLPagina to dLTrecho do
       begin
         if matriz.pagina[refCol, refLin].caractere <> CARACTERE_NULO then
         begin
           if refCol < refColInicio then
           refColInicio := refCol;
           if refCol > refColFim then
           refColFim := refCol;
           if refLin < refLinInicio then
           refLinInicio := refLin;
           if refLin > refLinFim then
           refLinFim := refLin;
         end;
       end;

       corFundoPagina := editor.corFundo;
       if corFundoPagina = 8 then
       corFundoPagina := 16;

       writeln(arq, 'Program CodigoFontePaintZim20;');
       writeln(arq, '//Codigo fonte gerado pela tecnologia PaintZim20');
       writeln(arq, '//O codigo fonte gerado pelo PaintZim20 NAO e protegido por direitos autorais');
       writeln(arq, '//Use a vontade. ;)');
       writeln(arq, 'Uses crt;');
       writeln(arq, 'Var');
       writeln(arq, 'posX, posY : integer;');
       writeln(arq, 'Begin');
       writeln(arq, '  textbackground(', editor.corFundo ,'); clrscr; //Pinta todo o fundo da tela (Linha opcional)');
       writeln(arq, '  posX := 1; posY := 1; //Determina a posicao referencial dos caracteres na tela');

       posLinAbsoluta := 0;
       refColAnterior := maxInt;
       refLinAnterior := maxInt;
       caracAnterior := CARACTERE_NULO;
       primeiroCaractere := true;
        
	   corAnterior := 0;
       corFundoAnterior := 0;	   
	   caracAnteriorASCIIExtend := false;
	
       for refLin := refLinInicio to refLinFim do
       begin
         inc(posLinAbsoluta);
         posColAbsoluta := 0;

         for refCol := refColInicio to refColFim do
         begin
           inc(posColAbsoluta);
           caractere := matriz.pagina[refCol, refLin].caractere;

           if caractere <> CARACTERE_NULO then
           begin

             cor := matriz.pagina[refCol, refLin].cor;
             corFundo := matriz.pagina[refCol, refLin].corFundo;

             if (caractere >= 32) and (caractere <= 126) and
                (caractere <> ord(ASPASS)) then
             caracASCIIExtend := false
             else
             caracASCIIExtend := true;

             if (refCol - refColAnterior = 1) and
                (refLin = refLinAnterior) and
                (caracAnterior <> CARACTERE_NULO) then
             begin

               if (cor = corAnterior) and
                  (corFundo = corFundoAnterior) then
               begin

                 if caracASCIIExtend then
                 begin
                   if caracAnteriorASCIIExtend then
                   write(arq, ',#', caractere) else
                   write(arq, ASPASS, ',#', caractere);
                 end else
                 begin
                   if caracAnteriorASCIIExtend then
                   write(arq, ',', ASPASS, chr(caractere)) else
                   write(arq, chr(caractere));
                 end;

               end else
               begin
                 IniciaLinha;
               end;

             end else
             begin //Nova linha
               IniciaLinha;

             end;

             corAnterior := cor;
             corFundoAnterior := corFundo;

           end;

           refColAnterior := refCol;
           refLinAnterior := refLin;
           caracAnteriorASCIIExtend := caracASCIIExtend;
           caracAnterior := caractere;

         end;

         if (refLin = refLinFim) then
         if (caracAnteriorASCIIExtend) then
         writeln(arq, ');') else
         writeln(arq, ASPASS, ');');

       end;

       writeln(arq, '  readkey; //Pausa a execucao do programa (Linha opcional)');
       writeln(arq, 'End.');

       close(arq);
       ExportaCodigoPascal := true;
     end else
     begin
       ExportaCodigoPascal := false;
     end;
   end else
   ExportaCodigoPascal := true;

 End;

 {----------------------------------------------------
     Function ImportaArquivoTXT;
  -----------------------------------------------------}
 Function ImportaArquivoTXT(nomeArquivo : string) : boolean;
 Var
 arq : text;
 refCol, refLin : integer;
 caractere : char;
 caracteresIniciais : string[2];
 Begin
   if nomeArquivo <> NULO then
   begin
     assign(arq, concat(nomeArquivo,'.txt'));
     {$I-} reset(arq); {$I+}
     if IOResult = 0 then
     begin

       read(arq, caractere);
       caracteresIniciais := caractere;
       read(arq, caractere);
       caracteresIniciais := concat(caracteresIniciais, caractere);

       if ((copy(caracteresIniciais, 1, 1) = #255) and
          (copy(caracteresIniciais, 2, 1) = #254)) or
          ((copy(caracteresIniciais, 1, 1) = #254) and
          (copy(caracteresIniciais, 2, 1) = #255))  then
       begin
         ExibeInformacao('ERRO_ABRIR_ARQUIVO_TXT_UNICODE');
         ImportaArquivoTXT := true;
         close(arq);
         Exit;
       end else
       begin
         close(arq);
         {$I-} reset(arq); {$I+}
       end;

       historico.trocarCiclo := true;
       refLin := definicao.refLinPagina - 1 + cursor.posLin - 1;
       repeat

         inc(refLin);
         refCol := definicao.refColPagina - 1 + cursor.posCol - 1;
         repeat

           read(arq, caractere);

           inc(refCol);
           if (ord(caractere) <> 32) and
              (ord(caractere) <> 0) then
           begin
             InsereElemento(ord(caractere),
                            editor.corCaractere,
                            editor.CorFundoCaractere,
                            refCol, refLin);
             historico.trocarCiclo := false;
           end;
         until(eoln(arq));
         readln(arq);

       until(eof(arq));

       close(arq);
       ImportaArquivoTXT := true;

     end else
     begin
       ImportaArquivoTXT := false;
     end;

   end else
   ImportaArquivoTXT := true;
 End;

 {----------------------------------------------------
     Procedure GerenciaMenu;
  -----------------------------------------------------}
  Procedure GerenciaMenu (idMenu : string);
  Const
  SEPARADOR = '|';
  Var
  escolha : string;
  posColPainel, posLinPainel, refInicial : integer;

   {SUBFUNÇÃO DE GERENCIAMENU}
   Function CapturaFragmentoCadeia(cadeia : string;
                                   separador : char;
                                   posFrag : integer) : string;
    {CAPTURA FRAGMENTO EM UMA CADEIA
     'posFrag' armazena a posição do fragmento na cadeia
     'separador' armazena o separador dos fragmentos}
    Var
    cont : integer;
    fragmentoAtual : integer;
    caractere, fragmento : string;
    Begin
      fragmentoAtual := 1;
      fragmento := NULO;
      for cont := 1 to length(cadeia) do
      begin
        caractere := copy(cadeia, cont, 1);
        if caractere = separador then
        inc(fragmentoAtual);
        if (fragmentoAtual = posFrag) and
           (caractere <> separador) then
        begin
          if (fragmento = NULO) then
	      fragmento := caractere
	      else
	      fragmento := concat(fragmento, caractere);
	    end;
      end;
      CapturaFragmentoCadeia := fragmento;
    End;

    {SUBFUNÇÃO DE GERENCIAMENU}
    Function ExibeSelecaoMenu(cadeia : string;
                              posCol, posLin,
                              posInicialLista : integer) : string;
    Const
    COR_SELECAO = 15;
    COR_FUNDO_SELECAO = 1;
    COR = 16;
    COR_FUNDO = 7;
    Var
    quantFragmentos, refLista, aux : integer;
    tecla : string;
    Begin
      quantFragmentos := 0;
      refLista := posInicialLista;
      repeat
        inc(quantFragmentos);
      until(CapturaFragmentoCadeia(cadeia, SEPARADOR, quantFragmentos) = NULO);
      dec(quantFragmentos);
      tecla := TECLA_TAB;
      while (true) do
      begin
        if (tecla <> NULO) then
        begin

          if (tecla = TECLA_UP) then
          begin
            if (refLista > 1) then
            dec(refLista) else
            refLista := quantFragmentos;
          end else
          if (tecla = TECLA_DOWN) then
          begin
            if (refLista < quantFragmentos) then
            inc(refLista) else
            refLista := 1;
          end else

          if (tecla = TECLA_ENTER) then
          begin
            ExibeSelecaoMenu := CapturaFragmentoCadeia(cadeia, SEPARADOR, refLista);
            Exit;
          end;

          if (tecla = TECLA_ESC) then
          begin
            ExibeSelecaoMenu := NULO;
            Exit;
          end;

          for aux := 1 to quantFragmentos do
          begin
            gotoxy(posCol, posLin + aux - 1);
            if aux = refLista then
            begin
              textcolor(COR_SELECAO); textbackground(COR_FUNDO_SELECAO);
            end else
            begin
              textcolor(COR); textbackground(COR_FUNDO);
            end;
            write(CapturaFragmentoCadeia(cadeia, SEPARADOR, aux));
          end;
        end;
        tecla := ObtemTeclaPressionada;
      end;
    End;

  Begin

    if (upcase(idMenu) = 'SELECAO') then
    begin
      posColPainel := POSICAO_COL_TELA + 1;
      posLinPainel := POSICAO_LIN_TELA + 1;
      DesenhaPainel(posColPainel, posLinPainel, 33, 9, 'Selecao');
      escolha := ExibeSelecaoMenu('Copiar|Preencher|Apagar|Aplicar cor ao caractere|Aplicar cor ao fundo|Colorir somente caractere atual',
                                   posColPainel + 1, posLinPainel + 2, 1);
      MostraCursor(true);
      if (escolha <> NULO) then
      begin
        if (upcase(escolha) = 'COPIAR') then
        begin
          ManipulaAreaSelecionada('COPIAR');
          selecao.ativa := false;
        end else
        if (upcase(escolha) = 'PREENCHER') then
        begin
          ManipulaAreaSelecionada('PREENCHER');
          selecao.ativa := false;
        end else
        if (upcase(escolha) = 'APAGAR') then
        begin
          ManipulaAreaSelecionada('APAGAR');
          selecao.ativa := false;
        end else
        if (upcase(escolha) = 'APLICAR COR AO CARACTERE') then
        begin
          ManipulaAreaSelecionada('COLORIR_CARACTERE');
          selecao.ativa := false;
        end else
        if (upcase(escolha) = 'APLICAR COR AO FUNDO') then
        begin
          ManipulaAreaSelecionada('COLORIR_FUNDO_CARACTERE');
          selecao.ativa := false;
        end else
        if (upcase(escolha) = 'COLORIR SOMENTE CARACTERE ATUAL') then
        begin
          ManipulaAreaSelecionada('COLORIR_CARACTERE_ATUAL');
          selecao.ativa := false;
        end else
        {Recompoe a posicao original dos elementos do editor depois da
        acao sobre a area selecionada}
        definicao.refColPagina := selecao.cacheRefColPagina;
        definicao.refLinPagina := selecao.cacheRefLinPagina;
        cursor.posCol := selecao.cachePosColCursor;
        cursor.posLin := selecao.cachePosLinCursor;
      end;


      ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
      MostraCursor(true);

    end else

    if (upcase(idMenu) = 'SAIDA') then
    begin
      posColPainel := POSICAO_COL_TELA + 1;
      posLinPainel := POSICAO_LIN_TELA + 1;
      DesenhaPainel(posColPainel, posLinPainel, 19, 6, 'Confirmar saida');
      escolha := ExibeSelecaoMenu('Sair|Cancelar',
                                   posColPainel + 1, posLinPainel + 2, 2);
      ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
      MostraCursor(true);
      if (escolha <> NULO) then
      begin
        if (upcase(escolha) = 'SAIR') then
        begin
          definicao.finalizarPrograma := true;
        end else
        if (upcase(escolha) = 'CANCELAR') then
        begin
          definicao.finalizarPrograma := false;
        end;
      end;

    end else

    if (upcase(idMenu) = 'ATALHOS') then
    begin
      posColPainel := POSICAO_COL_TELA + 1;
      posLinPainel := POSICAO_LIN_TELA + 12;
      DesenhaPainel(posColPainel, posLinPainel, 23,9,'Atalhos');
      if not(editor.modoAtalho) then
      refInicial := 6
      else
      begin
        case(editor.refGrupoPredefinido) of
          1: refInicial := 1;
          2: refInicial := 2;
          3: refInicial := 3;
          4: refInicial := 4;
          5: refInicial := 5;
        end;
      end;
      escolha := ExibeSelecaoMenu('Retangulos|Retas|Conectores simples|Conectores duplos|Setas|Desativado',
                                   posColPainel + 1, posLinPainel + 2, refInicial);
      ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
      MostraCursor(true);
      if (escolha <> NULO) then
      begin
        if (upcase(escolha) = 'RETANGULOS') then
        begin
          editor.modoAtalho := true;
          DefineAtalhos(1);
        end else
        if (upcase(escolha) = 'RETAS') then
        begin
          editor.modoAtalho := true;
          DefineAtalhos(2);
        end else
        if (upcase(escolha) = 'CONECTORES SIMPLES') then
        begin
          editor.modoAtalho := true;
          DefineAtalhos(3);
        end else
        if (upcase(escolha) = 'CONECTORES DUPLOS') then
        begin
          editor.modoAtalho := true;
          DefineAtalhos(4);
        end else
        if (upcase(escolha) = 'SETAS') then
        begin
          editor.modoAtalho := true;
          DefineAtalhos(5);
        end else
        if (upcase(escolha) = 'DESATIVADO') then
        begin
          editor.modoAtalho := false;
        end;
      end;
    end else

    if (upcase(idMenu) = 'EXPORTAR') then
    begin
      posColPainel := POSICAO_COL_TELA + 1;
      posLinPainel := POSICAO_LIN_TELA + 1;
      DesenhaPainel(posColPainel, posLinPainel, 19,5,'Exportar');
      escolha := ExibeSelecaoMenu('HTML|Pascal',
                                   posColPainel + 1, posLinPainel + 2, 1);
      if (escolha <> NULO) then
      begin
        if (upcase(escolha) = 'HTML') then
        begin
          ExibeInformacao('PAINEL_OBTER_DADO');
          if not(ExportaArquivoHTML(ObtemCadeia('Exportar HTML', 'Nome do arquivo'))) then
          ExibeInformacao('ERRO_GERAR_ARQUIVO');
        end else
        if (upcase(escolha) = 'PASCAL') then
        begin
          ExibeInformacao('PAINEL_OBTER_DADO');
          if not(ExportaCodigoPascal(ObtemCadeia('Exportar Pascal', 'Nome do arquivo'), 1, 1,
                                     DIMENSAO_COL_PAGINA, DIMENSAO_LIN_PAGINA)) then
          ExibeInformacao('ERRO_GERAR_ARQUIVO');
        end;
      end;
      ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
      MostraCursor(true);

    end else

    if (upcase(idMenu) = 'MODO_INSERCAO') then
    begin
      posColPainel := POSICAO_COL_TELA + 1;
      posLinPainel := POSICAO_LIN_TELA + 1;
      DesenhaPainel(posColPainel, posLinPainel, 19,5,'Modo de insercao');
      if editor.modoContinuo then
      refInicial := 2 else refInicial := 1;
      escolha := ExibeSelecaoMenu('Normal|Continuo',
                                   posColPainel + 1, posLinPainel + 2, refInicial);
      ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
      MostraCursor(true);
      if (escolha <> NULO) then
      begin
        if (upcase(escolha) = 'NORMAL') then
        editor.modoContinuo := false
        else
        if (upcase(escolha) = 'CONTINUO') then
        begin
          editor.modoContinuo := true;
          historico.trocarCiclo := true;
        end;
      end;
    end;

  End;


 {----------------------------------------------------
     PROGRAMA PRINCIPAL - Basicamente controla as
     entradas do usuario
  -----------------------------------------------------}
Begin

  InicializaDefinicoes;

  while(true) do
  begin
    delay(10);

    definicao.tecla := ObtemTeclaPressionada;

    if (definicao.tecla <> NULO) then
    begin

      {GERENCIA O MOVIMENTO DO CURSOR}
      if (definicao.tecla = TECLA_UP) or
         (definicao.tecla = TECLA_DOWN) or
         (definicao.tecla = TECLA_RIGHT) or
         (definicao.tecla = TECLA_LEFT) then
      begin

        MostraCursor(false);

        if selecao.ativa then
        ExibeLimitesSelecao(selecao.posCol, selecao.posLin, selecao.dimCol, selecao.dimLin, false);

        if definicao.tecla = TECLA_UP then
        begin
          if cursor.posLin > 0 then
          dec(cursor.posLin);
        end else
        if definicao.tecla = TECLA_DOWN then
        begin
          if cursor.posLin < DIMENSAO_LIN_TELA + 1 then
          inc(cursor.posLin);
        end else
        if definicao.tecla = TECLA_RIGHT then
        begin
          if cursor.posCol < DIMENSAO_COL_TELA + 1 then
          inc(cursor.posCol);
        end else
        if definicao.tecla = TECLA_LEFT then
        begin
          if cursor.posCol > 0 then
          dec(cursor.posCol);
        end;

        if cursor.posLin = DIMENSAO_LIN_TELA + 1 then
        begin
          if definicao.refLinPagina < DIMENSAO_LIN_PAGINA then
          begin
            if definicao.refLinPagina + DIMENSAO_LIN_TELA - 1 <= DIMENSAO_LIN_PAGINA - DIMENSAO_LIN_TELA + 1 then
            begin
              cursor.posLin := 1;
              definicao.refLinPagina := definicao.refLinPagina + DIMENSAO_LIN_TELA;
              ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
            end else
            begin
              if definicao.refLinPagina < DIMENSAO_LIN_PAGINA - DIMENSAO_LIN_TELA + 1 then
              begin
                cursor.posLin := DIMENSAO_LIN_TELA - ((DIMENSAO_LIN_PAGINA - DIMENSAO_LIN_TELA + 1) - definicao.refLinPagina) + 1;
                definicao.refLinPagina := DIMENSAO_LIN_PAGINA - DIMENSAO_LIN_TELA + 1;
                ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
              end else
              cursor.posLin := DIMENSAO_LIN_TELA;
            end;
          end else
          begin
            cursor.posLin := DIMENSAO_LIN_TELA;
            ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
          end;
        end else

        if cursor.posLin = 0 then
        begin

          if definicao.refLinPagina > DIMENSAO_LIN_TELA then
          begin
            cursor.posLin := DIMENSAO_LIN_TELA;
            definicao.refLinPagina := definicao.refLinPagina - DIMENSAO_LIN_TELA;
            ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
          end else
          begin
            if definicao.refLinPagina > 1 then
            begin
              cursor.posLin := definicao.refLinPagina - 1;
              definicao.refLinPagina := 1;
              ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
            end else
            begin
              cursor.posLin := 1;
            end;
          end;

        end else

        if cursor.posCol = DIMENSAO_COL_TELA + 1 then
        begin
          if definicao.refColPagina < DIMENSAO_COL_PAGINA then
          begin
            if definicao.refColPagina + DIMENSAO_COL_TELA - 1 <= DIMENSAO_COL_PAGINA - DIMENSAO_COL_TELA + 1 then
            begin
              cursor.posCol := 1;
              definicao.refColPagina := definicao.refColPagina + DIMENSAO_COL_TELA;
              ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
            end else
            begin
              if definicao.refColPagina < DIMENSAO_COL_PAGINA - DIMENSAO_COL_TELA + 1 then
              begin
                cursor.posCol := DIMENSAO_COL_TELA - ((DIMENSAO_COL_PAGINA - DIMENSAO_COL_TELA + 1) - definicao.refColPagina) + 1;
                definicao.refColPagina := DIMENSAO_COL_PAGINA - DIMENSAO_COL_TELA + 1;
                ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
              end else
              cursor.posCol := DIMENSAO_COL_TELA;
            end;
          end else
          begin
            cursor.posCol := DIMENSAO_COL_TELA;
            ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
          end;
        end else

        if cursor.posCol = 0 then
        begin

          if definicao.refColPagina > DIMENSAO_COL_TELA then
          begin
            cursor.posCol := DIMENSAO_COL_TELA;
            definicao.refColPagina := definicao.refColPagina - DIMENSAO_COL_TELA;
            ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
          end else
          begin
            if definicao.refColPagina > 1 then
            begin
              cursor.posCol := definicao.refColPagina - 1;
              definicao.refColPagina := 1;
              ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
            end else
            begin
              cursor.posCol := 1;
            end;
          end;

        end;

        if selecao.ativa then
        GerenciaSelecao;

        MostraCursor(true);

      end else

      {GERENCIA O MOVIMENTO DA TELA}
      if (definicao.tecla = TECLA_CTRL_UP) or
         (definicao.tecla = TECLA_CTRL_DOWN) or
         (definicao.tecla = TECLA_CTRL_RIGHT) or
         (definicao.tecla = TECLA_CTRL_LEFT) then
      begin

        if selecao.ativa then
        ExibeLimitesSelecao(selecao.posCol, selecao.posLin, selecao.dimCol, selecao.dimLin, false);

        if definicao.tecla = TECLA_CTRL_UP then
        begin
          if definicao.refLinPagina > 1 then
          dec(definicao.refLinPagina);
        end else
        if definicao.tecla = TECLA_CTRL_DOWN then
        begin
          if definicao.refLinPagina < DIMENSAO_LIN_PAGINA - DIMENSAO_LIN_TELA + 1 then
          inc(definicao.refLinPagina);
        end else
        if definicao.tecla = TECLA_CTRL_RIGHT then
        begin
          if definicao.refColPagina < DIMENSAO_COL_PAGINA - DIMENSAO_COL_TELA + 1 then
          inc(definicao.refColPagina);
        end else
        if definicao.tecla = TECLA_CTRL_LEFT then
        begin
          if definicao.refColPagina > 1 then
          dec(definicao.refColPagina);
        end;

        ExibeTela(definicao.refColPagina, definicao.refLinPagina, false);
        MostraCursor(true);

        if selecao.ativa then
        GerenciaSelecao;

      end else

      {GERENCIA A FUNÇÃO DA COMBINAÇÃO CTRL+A}
      if definicao.tecla = TECLA_CTRL_A then
      begin
        ExibeInformacao('PAINEL_OBTER_DADO');
        editor.nomeArquivoAux := ObtemCadeia('Abrir', 'Nome do arquivo');
        if (editor.nomeArquivoAux <> NULO) then
        begin
          if not(CarregaArquivoPaintZim20(editor.nomeArquivoAux)) then
          ExibeInformacao('ERRO_ABRIR_ARQUIVO') else
          begin
            //editor.nomeArquivo := editor.nomeArquivoAux;
            ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
            MostraCursor(true);
          end;
        end else
        begin
          ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
          MostraCursor(true);
        end;
      end else

      {GERENCIA A FUNÇÃO DA COMBINAÇÃO CTRL+B}
      if definicao.tecla = TECLA_CTRL_B then
      begin
        if not(editor.arquivoAberto) then
        begin
          ExibeInformacao('PAINEL_OBTER_DADO');
          editor.nomeArquivoAux := ObtemCadeia('Salvar como', 'Nome do arquivo');
          if (editor.nomeArquivoAux <> NULO) then
          begin
            if not(SalvaArquivoPaintZim20(editor.nomeArquivoAux)) then
            ExibeInformacao('ERRO_GERAR_ARQUIVO') else
            begin
              //editor.nomeArquivo := editor.nomeArquivoAux;
              ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
              MostraCursor(true);
            end;
          end else
          begin
            ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
            MostraCursor(true);
          end;
        end else
        begin
          if SalvaArquivoPaintZim20(editor.nomeArquivo) then
          ExibeInformacao('PAINEL_CONFIRMACAO_SALVAMENTO');
        end;
      end else

      {GERENCIA A FUNÇÃO DA COMBINAÇÃO CTRL+E}
      if definicao.tecla = TECLA_CTRL_E then
      begin
        ExibeInformacao('PAINEL_MENU_GENERICO');
        GerenciaMenu('EXPORTAR');
      end else

      {GERENCIA A FUNÇÃO DA COMBINAÇÃO CTRL+L}
      if definicao.tecla = TECLA_CTRL_L then
      begin
        editor.caractere := matriz.pagina[definicao.refColPagina - 1 + cursor.posCol,
                                          definicao.refLinPagina - 1 + cursor.posLin].caractere;
        editor.corCaractere := matriz.pagina[definicao.refColPagina - 1 + cursor.posCol,
                                             definicao.refLinPagina - 1 + cursor.posLin].cor;
        editor.corFundoCaractere := matriz.pagina[definicao.refColPagina - 1 + cursor.posCol,
                                                  definicao.refLinPagina - 1 + cursor.posLin].corFundo;
      end else

      {GERENCIA A FUNÇÃO DA COMBINAÇÃO CTRL+R}
      if definicao.tecla = TECLA_CTRL_R then
      begin
        RefazUltimaAcao;
        ExibeTela(definicao.refColPagina, definicao.refLinPagina, false);
      end else

      {GERENCIA A FUNÇÃO DA COMBINAÇÃO CTRL+ALT+B}
      if definicao.tecla = TECLA_CTRL_ALT_B then
      begin
        ExibeInformacao('PAINEL_OBTER_DADO');
        editor.nomeArquivoAux := ObtemCadeia('Salvar como', 'Nome do arquivo');
        if (editor.nomeArquivoAux <> NULO) then
        begin
          if not(SalvaArquivoPaintZim20(editor.nomeArquivoAux)) then
          ExibeInformacao('ERRO_GERAR_ARQUIVO') else
          begin
            //editor.nomeArquivo := editor.nomeArquivoAux;
            ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
            MostraCursor(true);
          end;
        end else
        begin
          ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
          MostraCursor(true);
        end;
      end else

      {GERENCIA A FUNÇÃO DA COMBINAÇÃO CTRL+T}
      if definicao.tecla = TECLA_CTRL_T then
      begin
        selecao.ativa := true;
        selecao.posCol := 1;
        selecao.posLin := 1;
        selecao.dimCol := DIMENSAO_COL_PAGINA;
        selecao.dimLin := DIMENSAO_LIN_PAGINA;
        selecao.cachePosColCursor := cursor.posCol;
        selecao.cachePosLinCursor := cursor.posLin;
        selecao.cacheRefColPagina := definicao.refColPagina;
        selecao.cacheRefLinPagina := definicao.refLinPagina;
        cursor.posCol := DIMENSAO_COL_TELA;
        cursor.posLin := DIMENSAO_LIN_TELA;
        definicao.refColPagina := DIMENSAO_COL_PAGINA - DIMENSAO_COL_TELA + 1;
        definicao.refLinPagina := DIMENSAO_LIN_PAGINA - DIMENSAO_LIN_TELA + 1;
        ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
        MostraCursor(true);
      end else

      {GERENCIA A FUNÇÃO DA COMBINAÇÃO CTRL+Z}
      if definicao.tecla = TECLA_CTRL_Z then
      begin
        DesfazUltimaAcao;
        ExibeTela(definicao.refColPagina, definicao.refLinPagina, false);
      end else

      {GERENCIA A FUNÇÃO DA COMBINAÇÃO CTRL+V}
      if definicao.tecla = TECLA_CTRL_V then
      begin
        ColaSelecao(true);
        ExibeTela(definicao.refColPagina, definicao.refLinPagina, false);
      end else

      {GERENCIA A FUNÇÃO DA COMBINAÇÃO ALT+V}
      if definicao.tecla = TECLA_ALT_V then
      begin
        ColaSelecao(false);
        ExibeTela(definicao.refColPagina, definicao.refLinPagina, false);
      end else

      {GERENCIA A FUNÇÃO DA TECLA ENTER}
      if definicao.tecla = TECLA_ENTER then
      begin

        if selecao.ativa then
        begin
          editor.temporizador := 1;
          ExibeLimitesSelecao(selecao.posCol, selecao.posLin, selecao.dimCol, selecao.dimLin, true);
          ExibeInformacao('PAINEL_MENU_GENERICO');
          GerenciaMenu('SELECAO');
          //ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
        end else
        begin

          historico.trocarCiclo := true;
          InsereElemento(editor.caractere, editor.corCaractere, editor.corFundoCaractere,
                         definicao.refColPagina - 1 + cursor.posCol,
                         definicao.refLinPagina - 1 + cursor.posLin);

          ExibeTela(definicao.refColPagina, definicao.refLinPagina, false);

        end;

      end else

      {GERENCIA A FUNÇÃO DA COMBINAÇÃO CTRL+ALT+ENTER}
      if definicao.tecla = TECLA_CTRL_ALT_ENTER then
      begin
        historico.trocarCiclo := true;
        InsereElemento(matriz.pagina[definicao.refColPagina - 1 + cursor.posCol,
                                     definicao.refLinPagina - 1 + cursor.posLin].caractere,
                                     editor.corCaractere, editor.corFundoCaractere,
                                     definicao.refColPagina - 1 + cursor.posCol,
                                     definicao.refLinPagina - 1 + cursor.posLin);
        ExibeTela(definicao.refColPagina, definicao.refLinPagina, false);
      end else

      {GERENCIA A FUNÇÃO DA COMBINAÇÃO CTRL+ENTER}
      if definicao.tecla = TECLA_CTRL_ENTER then
      begin
        if not(selecao.ativa) then
        begin
          selecao.ativa := true;
          selecao.posCol := definicao.refColPagina + cursor.posCol - 1;
          selecao.posLin := definicao.refLinPagina + cursor.posLin - 1;
          selecao.dimCol := 1;
          selecao.dimLin := 1;
          selecao.cachePosColCursor := cursor.posCol;
          selecao.cachePosLinCursor := cursor.posLin;
          selecao.cacheRefColPagina := definicao.refColPagina;
          selecao.cacheRefLinPagina := definicao.refLinPagina;
          //ExibePainelInformacao('PAINEL');
        end else
        begin
          {InvocaMenu('MENU_SELECAO');
          MostraCursor(true);}
        end;
        //ExibeHistorico;
      end else
      
      {GERENCIA A FUNÇÃO DA TECLA F1}
      if definicao.tecla = TECLA_F1 then
      begin
        ExibeInformacao('PAINEL_AJUDA');
        MostraCursor(true);
      end else

      {GERENCIA A FUNÇÃO DA TECLA F3}
      if definicao.tecla = TECLA_F3 then
      begin
        ExibeInformacao('PAINEL_SOBRE');
      end else

      {GERENCIA A FUNÇÃO DA TECLA F4}
      if definicao.tecla = TECLA_F4 then
      begin
        ExibeInformacao('PAINEL_MENU_GENERICO');
        GerenciaMenu('MODO_INSERCAO');
      end else

      {GERENCIA A FUNÇÃO DA TECLA F5}
      if definicao.tecla = TECLA_F5 then
      begin
        ExibeInformacao('PAINEL_CARACTERE');
        SelecionaCaractere;
      end else

      {GERENCIA A FUNÇÃO DA TECLA F9}
      if definicao.tecla = TECLA_F9 then
      begin
        ExibeInformacao('PAINEL_COR_CARACTERE');
        SelecionaCor('CARACTERE');
      end else

      {GERENCIA A FUNÇÃO DA TECLA F10}
      if definicao.tecla = TECLA_F10 then
      begin
        ExibeInformacao('PAINEL_COR_PAGINA');
        SelecionaCor('PAGINA');
      end else

      {GERENCIA A FUNÇÃO DA TECLA F6}
      if definicao.tecla = TECLA_F6 then
      begin
        ExibeInformacao('PAINEL_OBTER_DADO');
        if not(ImportaArquivoTXT(ObtemCadeia('Importar TXT', 'Nome do arquivo'))) then
        ExibeInformacao('ERRO_ABRIR_ARQUIVO')
        else
        ExibeTela(definicao.refColPagina, definicao.refLinPagina, true);
        MostraCursor(true);
      end else

      {GERENCIA A FUNÇÃO DA TECLA F12}
      if definicao.tecla = TECLA_F12 then
      begin
        ExibeInformacao('PAINEL_MENU_GENERICO');
        GerenciaMenu('ATALHOS');
      end else

      {GERENCIA A FUNÇÃO DA TECLA DELETE}
      if definicao.tecla = TECLA_DELETE then
      begin

        if historico.quantElementosDesfazer > 0 then

          historico.trocarCiclo := true;
          InsereElemento(CARACTERE_NULO, editor.corFundo, editor.corFundO,
                         definicao.refColPagina - 1 + cursor.posCol,
                         definicao.refLinPagina - 1 + cursor.posLin);

          ExibeTela(definicao.refColPagina, definicao.refLinPagina, false);
      end else

      {GERENCIA A FUNÇÃO DA TECLA ESC}
      if definicao.tecla = TECLA_ESC then
      begin

        if selecao.ativa then
        begin
          ExibeLimitesSelecao(selecao.posCol, selecao.posLin, selecao.dimCol, selecao.dimLin, false);
          selecao.ativa := false;
          MostraCursor(false);
          definicao.refColPagina := selecao.cacheRefColPagina;
          definicao.refLinPagina := selecao.cacheRefLinPagina;
          cursor.posCol := selecao.cachePosColCursor;
          cursor.posLin := selecao.cachePosLinCursor;
          ExibeTela(definicao.refColPagina, definicao.refLinPagina, false);
          MostraCursor(true);
        end else
        begin
          ExibeInformacao('PAINEL_MENU_GENERICO');
          GerenciaMenu('SAIDA');

          if definicao.finalizarPrograma then
          begin
            textbackground(16); clrscr;
            Exit;
          end;
        end;

      end else

      {GERENCIA A FUNÇÃO DA TECLA BACKSPACE}
      if (definicao.tecla = TECLA_BACKSPACE) then
      begin

        if selecao.ativa then
        ExibeLimitesSelecao(selecao.posCol, selecao.posLin, selecao.dimCol, selecao.dimLin, false);

        historico.trocarCiclo := true;
        if matriz.pagina[definicao.refColPagina - 1 + cursor.posCol - 1,
                         definicao.refLinPagina - 1 + cursor.posLin].caractere = CARACTERE_NULO then
        InsereElemento(CARACTERE_NULO, editor.corFundo, editor.corFundo,
                       definicao.refColPagina - 1 + cursor.posCol - 1,
                       definicao.refLinPagina - 1 + cursor.posLin)
        else
        InsereElemento(StringParaInt(TECLA_SPACE),
                       matriz.pagina[definicao.refColPagina - 1 + cursor.posCol - 1, definicao.refLinPagina - 1 + cursor.posLin].corFundo,
                       matriz.pagina[definicao.refColPagina - 1 + cursor.posCol - 1, definicao.refLinPagina - 1 + cursor.posLin].corFundo,
                       definicao.refColPagina - 1 + cursor.posCol - 1,
                       definicao.refLinPagina - 1 + cursor.posLin);


        if cursor.posCol > 1 then
        begin
          MostraCursor(false);
          dec(cursor.posCol);
          MostraCursor(true);
        end else
        begin
          if definicao.refColPagina > 1 then
          begin
            dec(definicao.refColPagina);
            ExibeTela(definicao.refColPagina, definicao.refLinPagina, false);
            MostraCursor(true);
          end;
        end;

        if selecao.ativa then
        GerenciaSelecao;

      end else

      {GERENCIA A DIGITAÇÃO DE TEXTOS}
      if (copy(definicao.tecla, 1, 1) <> '0') and
         not(editor.modoAtalho and
            ((StringParaInt(definicao.tecla) >= 48) and
             (StringParaInt(definicao.tecla) <= 57))) then
      begin

        if selecao.ativa then
        ExibeLimitesSelecao(selecao.posCol, selecao.posLin, selecao.dimCol, selecao.dimLin, false);

        historico.trocarCiclo := true;
        InsereElemento(StringParaInt(definicao.tecla), editor.corCaractere, editor.corFundoCaractere,
                       definicao.refColPagina - 1 + cursor.posCol,
                       definicao.refLinPagina - 1 + cursor.posLin);

        if cursor.posCol < DIMENSAO_COL_TELA then
        begin
          ExibeTela(definicao.refColPagina, definicao.refLinPagina, false);
          MostraCursor(false);
          inc(cursor.posCol);
          MostraCursor(true);
        end else
        begin
          if definicao.refColPagina < DIMENSAO_COL_PAGINA - DIMENSAO_COL_TELA + 1 then
          begin
            inc(definicao.refColPagina);
            ExibeTela(definicao.refColPagina, definicao.refLinPagina, false);
            MostraCursor(true);
          end;
        end;

        if selecao.ativa then
        GerenciaSelecao;

      end;

      {GERENCIA O USO DE ATALHOS}
      if (editor.modoAtalho) then
      begin
        if (definicao.tecla = TECLA_0) then
        editor.caractere := editor.grupoPredefinido[0]
        else
        if (definicao.tecla = TECLA_1) then
        editor.caractere := editor.grupoPredefinido[1]
        else
        if (definicao.tecla = TECLA_2) then
        editor.caractere := editor.grupoPredefinido[2]
        else
        if (definicao.tecla = TECLA_3) then
        editor.caractere := editor.grupoPredefinido[3]
        else
        if (definicao.tecla = TECLA_4) then
        editor.caractere := editor.grupoPredefinido[4]
        else
        if (definicao.tecla = TECLA_5) then
        editor.caractere := editor.grupoPredefinido[5]
        else
        if (definicao.tecla = TECLA_6) then
        editor.caractere := editor.grupoPredefinido[6]
        else
        if (definicao.tecla = TECLA_7) then
        editor.caractere := editor.grupoPredefinido[7]
        else
        if (definicao.tecla = TECLA_8) then
        editor.caractere := editor.grupoPredefinido[8]
        else
        if (definicao.tecla = TECLA_9) then
        editor.caractere := editor.grupoPredefinido[9];
      end;


      {Realiza a inserção de caracteres no modo contínuo}
      if (editor.modoContinuo) and
         (definicao.tecla <> NULO) then
      begin
        InsereElemento(editor.caractere, editor.corCaractere, editor.corFundoCaractere,
                       definicao.refColPagina - 1 + cursor.posCol,
                       definicao.refLinPagina - 1 + cursor.posLin);
        historico.trocarCiclo := false;
      end;

      if (definicao.tecla <> TECLA_UP) and
         (definicao.tecla <> TECLA_DOWN) and
         (definicao.tecla <> TECLA_RIGHT) and
         (definicao.tecla <> TECLA_LEFT) and
         (definicao.tecla <> TECLA_CTRL_UP) and
         (definicao.tecla <> TECLA_CTRL_DOWN) and
         (definicao.tecla <> TECLA_CTRL_RIGHT) and
         (definicao.tecla <> TECLA_CTRL_LEFT) and
         (definicao.tecla <> TECLA_CTRL_Z) and
         (definicao.tecla <> TECLA_CTRL_R) and
         (definicao.tecla <> TECLA_BACKSPACE) then
      begin
        {Realiza a invocação de alguns painéis de informação}

        ExibeInformacao('PAINEL_CABECALHO_1');

        if selecao.ativa then
        ExibeInformacao('PAINEL_SELECAO')
        else
        if editor.modoAtalho then
        ExibeInformacao('PAINEL_ATALHOS')
        else
        ExibeInformacao('PAINEL_PADRAO');
      end;

      if not(selecao.ativa) then
      ExibeInformacao('PAINEL_STATUS') else
      ExibeInformacao('PAINEL_DIMENSAO_SELECAO');


    end;

    {AÇÕES EM CONSTANTE LOOP}

    {Realiza a contagem do temporizador}
    if editor.temporizador = TEMPO_MAX_TEMPORIZADOR then
    editor.temporizador := 1
    else
    inc(editor.temporizador);

    {Realiza a invocação da exibição dos limites da seleção}
    if selecao.ativa then
    ExibeLimitesSelecao(selecao.posCol, selecao.posLin, selecao.dimCol, selecao.dimLin, true);

  end;
End.
