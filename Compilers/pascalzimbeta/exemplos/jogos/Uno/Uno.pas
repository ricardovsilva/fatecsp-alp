Program Uno;
{Nome: Jogo do Uno
 Autor: Guilherme Resende Sá
 Programa que implementa o jogo de cartas UNO com IA.
 O programa é uma cortesia ao querido Pascalzim

 ATENÇÃO:
 Por questões técnicas, para funcionar é necessário gerar 
 o executável (Menu Compilar/Gerar Executável) e iniciar o 
 programa fora do editor do Pascalzim.
 A pasta "Dados" precisa estar na mesma pasta do executável.
 A pasta "Dados" contém principalmente as imagens ASCII utilizadas
 no jogo e que foram elaboradas no editor PaintZim.

 O programa não é livre de bugs. Avise o autor caso algum seja
 encontrado.}
 
Uses
Crt, 
UnitElementosVisuais, {Possui funções para desenhar os retângulos, contornos, "janelas", "botões" entre outros} 
UnitPaintZim; {Possui a função de carregar e desenhar o conteúdo de um arquivo .paintzim}

  Type
      cartaType = Record
                    cor : integer;
                    valor : integer;
                  End;
    jogadorType = Record
                    nome : string;
                    mao : array[1..109] of cartaType;
                    quantCartas, pontuacao : integer;
                    uno : boolean;
                  End;
  Const
  CARTA_0 = 0; CARTA_1 = 1; CARTA_2 = 2; CARTA_3 = 3; CARTA_4 = 4;
  CARTA_5 = 5; CARTA_6 = 6; CARTA_7 = 7; CARTA_8 = 8; CARTA_9 = 9;
  CARTA_COMPRA_2 = 10;
  CARTA_INVERTE = 11;
  CARTA_PULA = 12;
  CARTA_COMPRA_4 = 13;
  CARTA_CORINGA = 14;
  COR_VERMELHA = RED;
  COR_AZUL = BLUE;
  COR_VERDE = GREEN;
  COR_AMARELA = YELLOW;
  COR_CORINGA = BLACK;
  QUANT_CARTAS_MAO = 7;
  COR_FUNDO = 3;
  VALOR_NULL = 999;
  //PONTOS_VITORIA = 500;

  DIRETORIO_DADOS = '.\DADOS';

  //CONSTANTES DE TECLAS
  TECLA_UP = '072';
  TECLA_DOWN = '080';
  TECLA_RIGHT = '077';
  TECLA_LEFT = '075';
  TECLA_ENTER = '13';
  TECLA_ESC = '27';
  TECLA_BACKSPACE = '8';
  TECLA_TAB = '9';
  TECLA_NULA = '\NULA';
  ID_NULL = '\NULL';

  Var
  partida : Record
             monte : array [1..109] of cartaType;
             jogador : array [1..10] of jogadorType;
             jogadorRodada, quantJogadores, quantCartasMonte : integer;
             refJogadorHumano, acumulado, quantCartasDisponiveis : integer;
             cartaAtual : cartaType;
             sentido, jogadorVenceuRodada, vezHumano, inicio: boolean;
             pontosVitoria : integer;
            End;
  layout : Record
             painel : array [1..7] of cartaType;
             posSelecionada, posSelecionadaAntiga, posSecao, refSecaoBaralho, contadorBloqueio : integer;
             leituraTeclado : string;
           End;
  fimUno : boolean;

  {------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------
    BLOCO "ROTINAS_GENERICAS"

    Este bloco contém rotinas de uso genérico ao programa
   ------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------}


  {------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------
    Function ObtemTeclaPressionada();
   ------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------}

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
                 tecla := TECLA_NULA;
               end;
        else begin
               str(ord(refA), auxA);
               tecla := auxA;
             end;
      end;
    end else
    begin
      tecla := TECLA_NULA;
    end;
    ObtemTeclaPressionada := tecla;
  End;

  {------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------
    Function LeDado();
   ------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------}  
  
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
      if tecla <> TECLA_NULA then
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
          LeDado := TECLA_NULA;
          CursorOff;
          break;
        end;
      end;

    end;

  End;

  {--------------------------------------------------------------------
      RetornaProximoJogador: Recebe a referência a um jogador e retorna seu sucessor
  ---------------------------------------------------------------------}
  Function RetornaProximoJogador(refJogadorAtual : integer) : integer;
  Var
  proximoJogador : integer;
  Begin
    if partida.sentido then
    begin
      if refJogadorAtual < partida.quantJogadores then
      proximoJogador := refJogadorAtual + 1
      else
      proximoJogador := 1;
    end else
    begin
      if refJogadorAtual > 1 then
      proximoJogador := refJogadorAtual - 1
      else
      proximoJogador := partida.quantJogadores;
    end;
    RetornaProximoJogador := proximoJogador;
  End;

  {--------------------------------------------------------------------
      CartaJogavel : Verifica se tal carta é jogável
  ---------------------------------------------------------------------}
  Function CartaJogavel(carta : cartaType) : boolean;
  Begin
    if (carta.valor = partida.cartaAtual.valor) or
       (carta.cor = partida.cartaAtual.cor) or
       (carta.valor = CARTA_CORINGA) or
       (carta.valor = CARTA_COMPRA_4) then
    CartaJogavel := true
    else
    CartaJogavel := false;
  End;


  {--------------------------------------------------------------------
      ArquivosDisponiveis : Verifica se todos os arquivos externos estão presentes
  ---------------------------------------------------------------------}
  Function ArquivosDisponiveis : boolean;

    {TestaArquivo : Verifica se o arquivo é acessivel}
    Function ArquivoAcessivel (caminho : string) : boolean;
    Var
    arquivo : text;
    Begin

      assign(arquivo, caminho);
      {$I-} reset(arquivo); {$I+}
      if IOResult = 0 then
      begin
        close(arquivo);
        ArquivoAcessivel := true; 
      end else
      begin
        ArquivoAcessivel := false;
      end;

    End;

  Begin
    ArquivosDisponiveis := false;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\NUMERO_0.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\NUMERO_1.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\NUMERO_2.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\NUMERO_3.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\NUMERO_4.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\NUMERO_5.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\NUMERO_6.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\NUMERO_7.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\NUMERO_8.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\NUMERO_9.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\NUMERO_+2.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\CORINGA.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\CORINGA_+4.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\INVERTE.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\PULA.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\COR_VERMELHA.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\COR_AZUL.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\COR_AMARELA.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\COR_VERDE.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\COR_CORINGA.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\VAZIO.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\FACE_MONTE.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\CARTA_NULA.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\CAIXA.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\LOGO.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\PASSARO.paintzim'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\MANUAL'))) then
    Exit;
    if not(ArquivoAcessivel(concat(DIRETORIO_DADOS, '\NOMES'))) then
    Exit;
    ArquivosDisponiveis := true;
  End;

  {------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------
    BLOCO "ROTINAS_GERENCIAMENTOEXIBICAO"

    Este bloco contém rotinas que administram a exibição
	de caracteres na tela, as cartas, painéis informativos,
    entre outros.
   ------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------}


  {--------------------------------------------------------------------
      ExibeCarta : Desenha uma carta
  ---------------------------------------------------------------------}
  Procedure DesenhaCarta(valor, cor, posCol, posLin : integer);
  Var
  nomeArquivo : string;
  Begin
    case valor of
      CARTA_0: nomeArquivo := 'NUMERO_0';
      CARTA_1: nomeArquivo := 'NUMERO_1';
      CARTA_2: nomeArquivo := 'NUMERO_2';
      CARTA_3: nomeArquivo := 'NUMERO_3';
      CARTA_4: nomeArquivo := 'NUMERO_4';
      CARTA_5: nomeArquivo := 'NUMERO_5';
      CARTA_6: nomeArquivo := 'NUMERO_6';
      CARTA_7: nomeArquivo := 'NUMERO_7';
      CARTA_8: nomeArquivo := 'NUMERO_8';
      CARTA_9: nomeArquivo := 'NUMERO_9';
      CARTA_COMPRA_2: nomeArquivo := 'NUMERO_+2';
      CARTA_INVERTE: nomeArquivo := 'INVERTE';
      CARTA_PULA: nomeArquivo := 'PULA';
      CARTA_COMPRA_4: nomeArquivo := 'CORINGA_+4';
      CARTA_CORINGA: nomeArquivo := 'CORINGA';
      VALOR_NULL: nomeArquivo := 'VAZIO'
      else nomeArquivo := 'CARTA_NULA';
    end;

    DesenhaRetangulo(CARACTERE_PADRAO, posCol, posLin, 10, 11, 7);
    if PaintZim(concat(DIRETORIO_DADOS, '\', nomeArquivo), posCol, posLin, false) then
    begin end;
    if nomeArquivo <> 'VAZIO' then
    begin
      case cor of
        COR_VERMELHA: nomeArquivo := 'COR_VERMELHA';
        COR_AZUL: nomeArquivo := 'COR_AZUL';
        COR_VERDE: nomeArquivo := 'COR_VERDE';
        COR_AMARELA: nomeArquivo := 'COR_AMARELA';
        COR_CORINGA: nomeArquivo := 'COR_CORINGA'
        else nomeArquivo := 'COR_CORINGA';
      end;
      if PaintZim(concat(DIRETORIO_DADOS, '\', nomeArquivo), posCol, posLin, false) then
      begin end;
    end;
    //gotoxy(posCol, posLin); textcolor(black); textbackground(7);
    //write(valor,'-',cor);
  End;


  {--------------------------------------------------------------------
      ExibeCartas : Gerencia a exibição das cartas da mão
  ---------------------------------------------------------------------}
  Procedure ExibeCartas(refMao : integer);
  Var
  auxA, posCol, posLin, quantCartasPainel : integer;
  Begin
    quantCartasPainel := partida.jogador[partida.refJogadorHumano].quantCartas;
    if quantCartasPainel > 7 then
    quantCartasPainel := 7;
    for auxA := 1 to quantCartasPainel do
    begin
      posCol := (4 + (auxA - 1) * 11) - 1;
      posLin := 14;
      DesenhaCarta(partida.jogador[partida.refJogadorHumano].mao[refMao + auxA - 1].valor,
                   partida.jogador[partida.refJogadorHumano].mao[refMao + auxA - 1].cor,
                   posCol,
                   posLin);
    end;
  End;


 {--------------------------------------------------------------------
      SelecionaCarta : Gerencia a exibição do destaque sobre as cartas
  ---------------------------------------------------------------------}
  Procedure SelecionaCarta;

    Procedure ApagaSelecao(posCol, posLin : integer);
    Begin
      DesenhaRetangulo(CARACTERE_PADRAO, posCol, posLin, 12, 1, 3);//Linha horizontal superior
      DesenhaRetangulo(CARACTERE_PADRAO, posCol, posLin + 13 - 1, 12, 1, 3);//Linha horizontal inferior
      DesenhaRetangulo(CARACTERE_PADRAO, posCol, posLin, 1, 13, 3);//Linha vertical da esquerda
      DesenhaRetangulo(CARACTERE_PADRAO, posCol + 12 - 1, posLin, 1, 13, 3);//Linha vertical da direita
    End;

  Begin

    if layout.posSelecionadaAntiga > 0 then
    ApagaSelecao((3 + (layout.posSelecionadaAntiga - 1) * 11) - 1, 13)
    else
    ApagaSelecao(2, 1);

    if layout.posSecao > 1 then
    begin
      DesenhaContorno((3 + (layout.posSelecionada - 1) * 11) - 1, 13, 12, 13, 15, 3, true);
      layout.posSelecionadaAntiga := layout.posSelecionada;
    end else
    begin
      DesenhaContorno(2, 1, 12, 13, 15, 3, true);
      layout.posSelecionadaAntiga := 0;
    end;
  End;


 {--------------------------------------------------------------------
      GerenciaPainelJogadores : Gerencia o painel que mostra os jogadores
  ---------------------------------------------------------------------}
  Procedure GerenciaPainelJogadores;
  Var                                                         
  auxA : integer;
  auxStr : string;
  Begin
    DesenhaRetangulo(CARACTERE_PADRAO, 58,2,21,11,3); //Apaga painel de jogadores
    for auxA := 1 to partida.quantJogadores do
    begin
      textbackground(COR_FUNDO);
      textcolor(white);
      if partida.jogadorRodada = auxA then
      textbackground(4)
      else
      if auxA = partida.refJogadorHumano then
      textcolor(yellow);


      gotoxy(71 - length(partida.jogador[auxA].nome) - 1, 1 + auxA);
      write(partida.jogador[auxA].nome);

      textbackground(COR_FUNDO);
      textcolor(black);

      if partida.jogador[auxA].quantCartas > 1 then
      str(partida.jogador[auxA].quantCartas, auxStr)
      else
      begin
        if partida.jogador[auxA].quantCartas > 0 then
        begin
           if partida.jogador[auxA].uno then
           auxStr := 'Uno'
           else
           auxStr := '1';
        end else
        auxStr := #1;
      end;

      gotoxy(73 - length(auxStr) + 1, 1 + auxA);
      write(auxStr);

      str(partida.jogador[auxA].pontuacao, auxStr);
      gotoxy(77 - length(auxStr) + 1, 1 + auxA);
      write(auxStr);

      gotoxy(78, 1 + auxA);
      textcolor(3); write(#219);
      gotoxy(78, 1 + auxA);
      textcolor(white);
      if auxA = partida.jogadorRodada then
        if partida.sentido then
        write(#25)
        else
        write(#24);

    end;
  End;

  {--------------------------------------------------------------------
      ExibeSetas : Exibe as setas indicadoras de continuação do baralho
  ---------------------------------------------------------------------}

  Procedure ExibeSetas;
  Begin
    if (layout.refSecaoBaralho > 7) then
    begin
      gotoxy(1, 19); textbackground(COR_FUNDO); textcolor(black); write(#27);
    end else
    begin
      gotoxy(1, 19); textbackground(COR_FUNDO); textcolor(COR_FUNDO); write(#219);
    end;
    if (layout.refSecaoBaralho + (7 - 1) < partida.jogador[partida.refJogadorHumano].quantCartas) then
    begin
      gotoxy(80, 19); textbackground(COR_FUNDO); textcolor(black); write(#26);
    end else
    begin
      gotoxy(80, 19); textbackground(COR_FUNDO); textcolor(COR_FUNDO); write(#219);
    end;
  End;

 {--------------------------------------------------------------------
      GerenciaPainelAvisos : Gerencia o painel que exibe os avisos
  ---------------------------------------------------------------------}
  Procedure GerenciaPainelInformacao(refAviso : integer);
  Const
  POSC_AVISOS = 14;
  POSL_AVISOS = 2;
  DIMC_AVISOS = 21;
  //DIML_AVISOS = 11;
  CORF_AVISO = 7;
  Var
  tecla : string;
  auxA, corSelecionada : integer;
  Begin
    case refAviso of
      0: begin
           DesenhaRetangulo(CARACTERE_PADRAO, 14,2,22,11,3);
         end;
      1: begin
           DesenhaPainel(POSC_AVISOS, POSL_AVISOS, DIMC_AVISOS, 5, 'Aviso', false, false);
           textcolor(black); textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 2);
           write(partida.jogador[partida.jogadorRodada].nome,' pediu a');
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 3);
           write('cor ');
           textcolor(partida.cartaAtual.cor);
           case partida.cartaAtual.cor of
             COR_VERMELHA: writeln('VERMELHA');
                 COR_AZUL: writeln('AZUL');
                COR_VERDE: writeln('VERDE');
              COR_AMARELA: writeln('AMARELA');
           end;
         end;
      2: begin
           DesenhaPainel(POSC_AVISOS, 8, DIMC_AVISOS, 5, 'Aviso', false, false);
           textcolor(black); textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 8);
           write(partida.jogador[partida.refJogadorHumano].nome,',');
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 9);
           write('sua vez de jogar!');
         end;
      3: begin
           DesenhaPainel(POSC_AVISOS, POSL_AVISOS, DIMC_AVISOS, 5, 'Aviso', false, false);
           textcolor(black); textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 2);
           write(partida.jogador[RetornaProximoJogador(partida.jogadorRodada)].nome);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 3);
           write('comprou +',2 * partida.acumulado,' cartas');
         end;
      4: begin
           DesenhaPainel(POSC_AVISOS, POSL_AVISOS, DIMC_AVISOS, 5, 'Aviso', false, false);
           textcolor(black); textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 2);
           write(partida.jogador[RetornaProximoJogador(partida.jogadorRodada)].nome);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 3);
           write('comprou +4 cartas');
           //delay(2000);
         end;
      5: begin
           //ReproduzSom('JOGA_CARTA_ESPECIAL');
           DesenhaPainel(POSC_AVISOS, POSL_AVISOS, DIMC_AVISOS, 5, 'Aviso', false, false);
           GerenciaPainelJogadores;
           textcolor(black); textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 2);
           write(partida.jogador[partida.jogadorRodada].nome);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 3);
           write('inverteu o sentido');
         end;
      6: begin
           //ReproduzSom('JOGA_CARTA_ESPECIAL');
           DesenhaPainel(POSC_AVISOS, POSL_AVISOS, DIMC_AVISOS, 5, 'Aviso', false, false);
           textcolor(black); textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 2);
           write(partida.jogador[partida.jogadorRodada].nome);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 3);
           write('pulou ', partida.jogador[RetornaProximoJogador(partida.jogadorRodada)].nome);
         end;
      7: begin
           DesenhaPainel(POSC_AVISOS, POSL_AVISOS, DIMC_AVISOS, 9, 'Aviso', false, false);
           textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 2);
           textcolor(black); write('Qual a cor deseja?');
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 4);
           textcolor(lightred); write('  VERMELHA');
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 5);
           textcolor(lightblue); write('  AZUL');
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 6);
           textcolor(yellow); write('  AMARELA');
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 7);
           textcolor(green); write('  VERDE');
           layout.posSelecionada := 4;
           SelecionaCarta;
           corSelecionada := 1;
           while(true) do
           begin

             for auxA := 1 to 4 do
             begin
               textcolor(black); textbackground(7);
               gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 3 + auxA);
               if corSelecionada = auxA then
               write(#16)
               else
               write(#255);
             end;

             tecla := ObtemTeclaPressionada;
             delay(50);
             if tecla = TECLA_ESC then
             begin
               //Exit;
             end else
             if tecla = TECLA_UP then
             begin
               if corSelecionada > 1 then
               dec(corSelecionada);
             end else
             if tecla = TECLA_DOWN then
             begin
               if corSelecionada < 4 then
               inc(corSelecionada);
             end else
             if tecla = TECLA_RIGHT then
             begin
               if layout.refSecaoBaralho <= partida.jogador[partida.refJogadorHumano].quantCartas - 7  then
               begin
                 layout.refSecaoBaralho := layout.refSecaoBaralho + 7;
                 ExibeCartas(layout.refSecaoBaralho);
                 ExibeSetas;
               end;
             end else
             if tecla = TECLA_LEFT then
             begin
                if layout.refSecaoBaralho >= (7 + 1) then
                begin
                  layout.refSecaoBaralho := layout.refSecaoBaralho - 7;
                  ExibeCartas(layout.refSecaoBaralho);
                  ExibeSetas;
                end;
             end else
             if tecla = TECLA_ENTER then
             begin
               case corSelecionada of
                 1: partida.cartaAtual.cor := COR_VERMELHA;
                 2: partida.cartaAtual.cor := COR_AZUL;
                 3: partida.cartaAtual.cor := COR_AMARELA;
                 4: partida.cartaAtual.cor := COR_VERDE;
               end;
               Exit;
             end else
             if (tecla = '85') or  {tecla 'U' ou 'u'}
                (tecla = '117') then
             begin
               if partida.jogador[partida.refJogadorHumano].quantCartas = 2 then
               begin
                 DesenhaBotao(47,10,6,1,3,3,15,true,'Uno[U]');
                 delay(300);
                 DesenhaBotao(47,10,6,1,3,3,15,false,'Uno[U]');
                 partida.jogador[partida.refJogadorHumano].uno := true;
               end;
             end;

           end;
         end;
      8: begin
           GerenciaPainelInformacao(0);
           DesenhaPainel(POSC_AVISOS, POSL_AVISOS, DIMC_AVISOS, 5, 'Aviso', false, false);
           textcolor(black); textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 2);
           write(partida.jogador[partida.jogadorRodada].nome);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 3);
           write('comprou e n',#198,'o jogou');
           //delay(2000);
         end;
      9: begin
           //ReproduzSom('ACUMULA');
           DesenhaPainel(POSC_AVISOS, POSL_AVISOS, DIMC_AVISOS, 5, 'Aviso', false, false);
           textcolor(black); textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 2);
           write(partida.jogador[partida.jogadorRodada].nome);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 3);
           write('acumulou +',2 * partida.acumulado,' cartas');
         end;
     10: begin
           //ReproduzSom('VENCEU_RODADA');
           DesenhaPainel(POSC_AVISOS, POSL_AVISOS, DIMC_AVISOS, 5, 'Aviso', false, false);
           textcolor(black); textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 2);
           write(partida.jogador[partida.jogadorRodada].nome);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 3);
           write('venceu a rodada!');
           //READKEY;
         end;
      11: begin
           //ReproduzSom('VENCEU_JOGO');
           DesenhaPainel(POSC_AVISOS, POSL_AVISOS, DIMC_AVISOS, 8, 'Aviso', false, false);
           textcolor(black); textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 2);
           write(partida.jogador[partida.jogadorRodada].nome);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 3);
           write('VENCEU O JOGO!');
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 5);
           write('Para continuar');
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 6);
           write('pressione [C]');
           //READKEY;
         end;
      12: begin
           //ReproduzSom('ALERTA_NAO_FALOU_UNO');
           DesenhaPainel(POSC_AVISOS, POSL_AVISOS, DIMC_AVISOS, 5, 'Aviso', false, false);
           textcolor(black); textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 2);
           write(partida.jogador[partida.jogadorRodada].nome, ' n',#198,'o');
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 3);
           write('disse UNO. Pegou +4');
           //READKEY;
         end;
      13: begin
           //ReproduzSom('ALERTA_UNO');
           DesenhaPainel(POSC_AVISOS, POSL_AVISOS, DIMC_AVISOS, 5, 'Aviso', false, false);
           textcolor(black); textbackground(CORF_AVISO);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 2);
           write(partida.jogador[partida.jogadorRodada].nome);
           gotoxy(POSC_AVISOS + 1, POSL_AVISOS + 3);
           write('disse UNO!');
           //READKEY;
         end;
    end;

  End;


  {--------------------------------------------------------------------
      ExibeCartaAtual : Desenha a carta da rodada
  ---------------------------------------------------------------------}
  Procedure ExibeCartaAtual;
  Begin
    DesenhaCarta(partida.cartaAtual.valor, partida.cartaAtual.cor, 36, 2);
  End;


  {------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------
    BLOCO "ROTINAS_PRIMITIVAS"

    Este bloco do programa contém algumas das rotinas
    básicas para o funcionamento do jogo. São elas:

    Procedure EmbaralhaCartas();
    Procedure PegaCarta();
   	Procedure DistribuiCartas();
   	Procedure ComputaPontuacao();
    Procedure JogaCarta();
    Procedure JogaIA(); -- Implementa a inteligência do jogo

   ------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------}

  {--------------------------------------------------------------------
     EmbaralhaCartas: Embaralha as cartas do monte
  ---------------------------------------------------------------------}
  Procedure EmbaralhaCartas;
  Const
  CICLOS_EMBARALHAMENTO = 5;
  Var
  auxA, auxB, auxC, auxD, posSorteada : integer;
  Begin
    randomize;
    for auxA := 1 to CICLOS_EMBARALHAMENTO do
    begin
      for auxB := 1 to partida.quantCartasMonte do
      begin
        posSorteada := random(partida.quantCartasMonte) + 1;
        auxC := partida.monte[auxB].valor;
        auxD := partida.monte[auxB].cor;
        partida.monte[auxB] := partida.monte[posSorteada];
        partida.monte[posSorteada].valor := auxC;
        partida.monte[posSorteada].cor := auxD;
      end;
    end;
  End;


  {--------------------------------------------------------------------
      PegaCarta: Dá uma quantidade de cartas a um jogador
  ---------------------------------------------------------------------}
  Procedure PegaCarta(quantCartas, jogadorRef : integer);
  Var
  auxA, auxB : integer;
  carta : cartaType;
  Begin
    //ReproduzSom('COMPRA_CARTA');
    for auxA := 1 to quantCartas do
    begin
      carta := partida.monte[1];
      dec(partida.quantCartasDisponiveis);
      for auxB := 1 to partida.quantCartasMonte do
      begin
        partida.monte[auxB] := partida.monte[auxB + 1];
      end;
      partida.monte[partida.quantCartasMonte].valor := VALOR_NULL;
      partida.monte[partida.quantCartasMonte].cor := VALOR_NULL;

      if partida.jogador[jogadorRef].uno then
      begin
        partida.jogador[jogadorRef].uno := false;
      end;

      dec(partida.quantCartasMonte);
      inc(partida.jogador[jogadorRef].quantCartas);
      partida.jogador[jogadorRef].mao[partida.jogador[jogadorRef].quantCartas] := carta;
      if partida.quantCartasDisponiveis = 0 then
      begin
        EmbaralhaCartas;
        partida.quantCartasDisponiveis := partida.quantCartasMonte;
      end;
    end;
    if jogadorRef = partida.refJogadorHumano then
    begin
      layout.refSecaoBaralho := (((partida.jogador[partida.refJogadorHumano].quantCartas - 1) div 7) * 7) + 1;
      layout.posSelecionada := partida.jogador[partida.refJogadorHumano].quantCartas - layout.refSecaoBaralho + 1;
      layout.posSecao := 2;
      ExibeSetas;
      ExibeCartas(layout.refSecaoBaralho);
      SelecionaCarta;
      if partida.jogador[partida.refJogadorHumano].quantCartas <= 2 then
      DesenhaBotao(47,10,6,1,3,3,15,false,'Uno[U]') else
      DesenhaRetangulo(CARACTERE_PADRAO, 47,10,10,3,3);
    end;
  End;

 {--------------------------------------------------------------------
      DistribuiCartas: Distribui as cartas para os jogadores
  ---------------------------------------------------------------------}
  Procedure DistribuiCartas;
  Var
  auxA : integer;
  Begin
    for auxA := 1 to partida.quantJogadores do
    begin
      PegaCarta(QUANT_CARTAS_MAO, auxA);
    end;
  End;


 {--------------------------------------------------------------------
      GerenciaVitoria : Gerencia a vitória de um jogador
  ---------------------------------------------------------------------}
  Procedure ComputaPontuacao;
  Var
  auxA, auxB, ponto, pontuacaoVencedor : integer;
  Begin
    pontuacaoVencedor := 0;
    for auxA := 1 to partida.quantJogadores do
    begin
      if auxA <> partida.jogadorRodada then
      begin
        for auxB := 1 to partida.jogador[auxA].quantCartas do
        begin
          case partida.jogador[auxA].mao[auxB].valor of
                   CARTA_0: ponto := 0;
                   CARTA_1: ponto := 1;
                   CARTA_2: ponto := 2;
                   CARTA_3: ponto := 3;
                   CARTA_4: ponto := 4;
                   CARTA_5: ponto := 5;
                   CARTA_6: ponto := 6;
                   CARTA_7: ponto := 7;
                   CARTA_8: ponto := 8;
                   CARTA_9: ponto := 9;
             CARTA_INVERTE: ponto := 20;
                CARTA_PULA: ponto := 20;
            CARTA_COMPRA_2: ponto := 20;
            CARTA_COMPRA_4: ponto := 50;
             CARTA_CORINGA: ponto := 50;
          end;
          pontuacaoVencedor := pontuacaoVencedor + ponto;
        end;
      end;
    end;
    partida.jogador[partida.jogadorRodada].pontuacao := partida.jogador[partida.jogadorRodada].pontuacao + pontuacaoVencedor;
    GerenciaPainelJogadores;
  End;

 {--------------------------------------------------------------------
      JogaCarta: Desce uma carta do jogador para a mesa
  ---------------------------------------------------------------------}
  Procedure JogaCarta(numCarta, jogadorRef : integer);
  Var
  auxA, auxB : integer;
  quantVermelha, quantAzul, quantAmarela, quantVerde, corEscolhida : integer;
  acumulado : boolean;
  Begin
    partida.cartaAtual := partida.jogador[jogadorRef].mao[numCarta];
    acumulado := false;

    if jogadorRef <> partida.refJogadorHumano then
    ExibeCartaAtual else
    if partida.jogador[jogadorRef].quantCartas <> 2 then
    ExibeCartaAtual;

    if (partida.jogador[jogadorRef].quantCartas = 2) and
       (jogadorRef <> partida.refJogadorHumano) then
    begin
      randomize;
      auxA := random(100) + 1;
      if auxA <= 95 then
      begin
        partida.jogador[jogadorRef].uno := true;
        GerenciaPainelInformacao(13);
        delay(2000);
      end else
      partida.jogador[jogadorRef].uno := false;
    end else
    begin
      if jogadorRef = partida.refJogadorHumano then
      begin
        case partida.jogador[jogadorRef].quantCartas of
          2: begin
               DesenhaRetangulo(CARACTERE_PADRAO, 47,10,10,3,3);
               if partida.jogador[jogadorRef].uno then
               begin
                 GerenciaPainelInformacao(13);
                 delay(2000);
                 if (partida.cartaAtual.valor <> CARTA_COMPRA_4) then
                 ExibeCartaAtual;
               end;
             end;
          3: DesenhaBotao(47,10,6,1,3,3,15,false,'Uno[U]');
        end;
      end;
    end;

    for auxA := numCarta to partida.jogador[jogadorRef].quantCartas do
    begin
      partida.jogador[jogadorRef].mao[auxA] := partida.jogador[jogadorRef].mao[auxA + 1];
    end;
    dec(partida.jogador[jogadorRef].quantCartas);
    inc(partida.quantCartasMonte);
    GerenciaPainelJogadores;
    partida.monte[partida.quantCartasMonte] := partida.cartaAtual;

    ExibeSetas;

    case partida.cartaAtual.valor of
            CARTA_PULA: begin
                          GerenciaPainelInformacao(0); GerenciaPainelInformacao(6);
                        end;
         CARTA_INVERTE: begin
                          GerenciaPainelInformacao(0);
                          partida.sentido := not(partida.sentido);
                          GerenciaPainelInformacao(5);
                        end;
        CARTA_COMPRA_2: begin
                          auxB := partida.jogador[RetornaProximoJogador(partida.jogadorRodada)].quantCartas; 
                          for auxA := 1 to auxB do
                          begin
                            if partida.jogador[RetornaProximoJogador(partida.jogadorRodada)].mao[auxA].valor = CARTA_COMPRA_2 then
                            begin
                              acumulado := true;
                              inc(partida.acumulado);
                              if partida.acumulado > 1 then
                              GerenciaPainelInformacao(9);
                              break;
                            end;
                          end;

                          if not(acumulado) then
                          begin

                            if (jogadorRef = partida.refJogadorHumano) then
                            begin
                              inc(partida.jogador[partida.refJogadorHumano].quantCartas);
                              ExibeCartas(layout.refSecaoBaralho);
                              dec(partida.jogador[partida.refJogadorHumano].quantCartas);
                            end;

                            inc(partida.acumulado);
                            if partida.acumulado > 1 then
                            begin
                              GerenciaPainelInformacao(9);
                              delay(1500);
                            end;
                            PegaCarta(2 * partida.acumulado, RetornaProximoJogador(partida.jogadorRodada));
                            GerenciaPainelJogadores;
                            GerenciaPainelInformacao(0); GerenciaPainelInformacao(3);
                            partida.acumulado := 0;
                          end;
                        end;
        CARTA_COMPRA_4: begin
                          //ReproduzSom('JOGA_CORINGA');
                          PegaCarta(4, RetornaProximoJogador(partida.jogadorRodada));
                          GerenciaPainelJogadores;
                          ExibeSetas;
                          GerenciaPainelInformacao(0);
                          GerenciaPainelInformacao(4);
                          ExibeCartaAtual;
                          if partida.jogadorRodada <> partida.refJogadorHumano then
                          delay(2000);
                        end;
         CARTA_CORINGA: begin
                          //ReproduzSom('JOGA_CORINGA');
                          ExibeSetas;
                          GerenciaPainelInformacao(0);
                        end;
        else begin
               GerenciaPainelInformacao(0);
             end;
    end;

    if (partida.jogador[jogadorRef].quantCartas = 1) and
       not(partida.jogador[jogadorRef].uno) then
    begin
      if (jogadorRef = partida.refJogadorHumano) then
      begin
        inc(partida.jogador[partida.refJogadorHumano].quantCartas);
        ExibeCartas(layout.refSecaoBaralho);
        dec(partida.jogador[partida.refJogadorHumano].quantCartas);
      end;
      GerenciaPainelInformacao(12);
      delay(2000);
      PegaCarta(4, partida.jogadorRodada);
    end;

    if partida.jogador[jogadorRef].quantCartas = 0 then
    begin
      partida.jogadorVenceuRodada := true;
      GerenciaPainelJogadores;
      Exit;
    end;

    if partida.jogadorRodada <> partida.refJogadorHumano then
    begin
      if (partida.cartaAtual.valor = CARTA_COMPRA_4) or
         (partida.cartaAtual.valor = CARTA_CORINGA) then
      begin

        quantVermelha := 0;
        quantAzul := 0;
        quantAmarela := 0;
        quantVerde := 0;

        for auxA := 1 to partida.jogador[partida.jogadorRodada].quantCartas do
        if partida.jogador[partida.jogadorRodada].mao[auxA].cor = COR_VERMELHA then
        inc(quantVermelha);
        for auxA := 1 to partida.jogador[partida.jogadorRodada].quantCartas do
        if partida.jogador[partida.jogadorRodada].mao[auxA].cor = COR_AZUL then
        inc(quantAzul);
        for auxA := 1 to partida.jogador[partida.jogadorRodada].quantCartas do
        if partida.jogador[partida.jogadorRodada].mao[auxA].cor = COR_AMARELA then
        inc(quantAmarela);
        for auxA := 1 to partida.jogador[partida.jogadorRodada].quantCartas do
        if partida.jogador[partida.jogadorRodada].mao[auxA].cor = COR_VERDE then
        inc(quantVerde);

        if (quantVermelha >= quantAzul) and
           (quantVermelha >= quantAmarela) and
           (quantVermelha >= quantVerde) then
        corEscolhida := 1
        else
        if (quantAzul >= quantVermelha) and
           (quantAzul >= quantAmarela) and
           (quantAzul >= quantVerde) then
        corEscolhida := 2
        else
        if (quantAmarela >= quantVermelha) and
           (quantAmarela >= quantAzul) and
           (quantAmarela >= quantVerde) then
        corEscolhida := 3
        else
        if (quantVerde >= quantVermelha) and
           (quantVerde >= quantAzul) and
           (quantVerde >= quantAmarela) then
        corEscolhida := 4
        else
        corEscolhida := random(4) + 1;

        case corEscolhida of
          1: begin
               partida.cartaAtual.cor := COR_VERMELHA;
             end;
          2: begin
               partida.cartaAtual.cor := COR_AZUL;
             end;
          3: begin
               partida.cartaAtual.cor := COR_VERDE;
             end;
          4: begin
             partida.cartaAtual.cor := COR_AMARELA;
             end;
        end;
        GerenciaPainelInformacao(1);
      end;
    end else
    begin
      if (partida.cartaAtual.valor = CARTA_COMPRA_4) or
         (partida.cartaAtual.valor = CARTA_CORINGA) or
         (partida.cartaAtual.valor = CARTA_COMPRA_2) then
      begin
        ExibeSetas;
        inc(partida.jogador[partida.refJogadorHumano].quantCartas);
        ExibeCartas(layout.refSecaoBaralho);
        dec(partida.jogador[partida.refJogadorHumano].quantCartas);
        if partida.cartaAtual.valor <> CARTA_CORINGA then
        delay(2000);
        if partida.cartaAtual.valor <> CARTA_COMPRA_2 then
        GerenciaPainelInformacao(7)
        else
        GerenciaPainelInformacao(0);
        //GerenciaPainelJogadores;
        GerenciaPainelInformacao(0);
        if partida.cartaAtual.valor <> CARTA_COMPRA_2 then
        GerenciaPainelInformacao(1);
      end;
    end;

    case partida.cartaAtual.valor of
            CARTA_PULA: partida.jogadorRodada := RetornaProximoJogador(RetornaProximoJogador(partida.jogadorRodada));
        CARTA_COMPRA_2: begin
                          if acumulado then
                          partida.jogadorRodada := RetornaProximoJogador(partida.jogadorRodada)
                          else
                          partida.jogadorRodada := RetornaProximoJogador(RetornaProximoJogador(partida.jogadorRodada));
                        end;
        CARTA_COMPRA_4: partida.jogadorRodada := RetornaProximoJogador(RetornaProximoJogador(partida.jogadorRodada));
        else begin
               partida.jogadorRodada := RetornaProximoJogador(partida.jogadorRodada);
             end;
    end;

  End;


  {--------------------------------------------------------------------
      JogaIA : Implementa a IA do jogo
  ---------------------------------------------------------------------}
  Procedure JogaIA (jogadorRef : integer);
  Var
  auxA, pontuacao, refCartaEscolhida : integer;

   {Subfunção VerificaCartasSemelhantes:
    Verifica a taxa de semelhanças com as outras cartas da mão
    e retorna um valor proporcional a quantidade de semelhanças}
    Function VerificaCartasSemelhantes(refCartaMao : integer) : integer;
    Var
    aux, recorrencia : integer;
    Begin
      recorrencia := 0;
      for aux := 1 to partida.jogador[jogadorRef].quantCartas do
      begin
        if aux <> refCartaMao then
        begin
          if partida.jogador[jogadorRef].mao[refCartaMao].valor =
             partida.jogador[jogadorRef].mao[aux].valor then
          inc(recorrencia);
          if partida.jogador[jogadorRef].mao[refCartaMao].cor =
             partida.jogador[jogadorRef].mao[aux].cor then
          inc(recorrencia);
        end;
      end;
      VerificaCartasSemelhantes := recorrencia;
    End;

  Begin
    layout.contadorBloqueio := 0;
    refCartaEscolhida := 0;
    pontuacao := 0;

    if partida.acumulado > 0 then
    begin
      for auxA := 1 to partida.jogador[jogadorRef].quantCartas do
      begin
        if CartaJogavel(partida.jogador[jogadorRef].mao[auxA]) and
          (partida.jogador[jogadorRef].mao[auxA].valor = CARTA_COMPRA_2) then
        begin
          if (VerificaCartasSemelhantes(auxA) >= pontuacao) or
             (pontuacao = 0) then
          begin
            pontuacao := VerificaCartasSemelhantes(auxA);
            refCartaEscolhida := auxA;
          end;
        end;
      end;

      if (refCartaEscolhida > 0) then
      begin
        JogaCarta(refCartaEscolhida, jogadorRef);
        Exit;
      end;
    end;

    if partida.jogador[RetornaProximoJogador(partida.jogadorRodada)].quantCartas < 3 then
    begin

      for auxA := 1 to partida.jogador[jogadorRef].quantCartas do
      begin
        if CartaJogavel(partida.jogador[jogadorRef].mao[auxA]) and
         ((partida.jogador[jogadorRef].mao[auxA].valor = CARTA_COMPRA_4) or
          (partida.jogador[jogadorRef].mao[auxA].valor = CARTA_COMPRA_2) or
          (partida.jogador[jogadorRef].mao[auxA].valor = CARTA_PULA) or
          (partida.jogador[jogadorRef].mao[auxA].valor = CARTA_INVERTE) or
          (partida.jogador[jogadorRef].mao[auxA].valor = CARTA_CORINGA)) then
        begin
          if (VerificaCartasSemelhantes(auxA) >= pontuacao) or
             (pontuacao = 0) then
          begin
            pontuacao := VerificaCartasSemelhantes(auxA);
            refCartaEscolhida := auxA;
          end;
        end;
      end;

      if (refCartaEscolhida > 0) then
      begin
        JogaCarta(refCartaEscolhida, jogadorRef);
        Exit;
      end;

    end;

    for auxA := 1 to partida.jogador[jogadorRef].quantCartas do
    begin
      if CartaJogavel(partida.jogador[jogadorRef].mao[auxA]) and
         (partida.jogador[jogadorRef].mao[auxA].valor <> CARTA_CORINGA) and
         (partida.jogador[jogadorRef].mao[auxA].valor <> CARTA_COMPRA_4) then
      begin
        if (VerificaCartasSemelhantes(auxA) >= pontuacao) or
           (pontuacao = 0) then
        begin
          pontuacao := VerificaCartasSemelhantes(auxA);
          refCartaEscolhida := auxA;
        end;
      end;
    end;
    if (refCartaEscolhida > 0) then
    begin
      JogaCarta(refCartaEscolhida, jogadorRef);
      Exit;
    end;

    for auxA := 1 to partida.jogador[jogadorRef].quantCartas do
    begin
      if CartaJogavel(partida.jogador[jogadorRef].mao[auxA]) and
       ((partida.jogador[jogadorRef].mao[auxA].valor = CARTA_CORINGA) or
        (partida.jogador[jogadorRef].mao[auxA].valor = CARTA_COMPRA_4)) then
      begin
        if (VerificaCartasSemelhantes(auxA) >= pontuacao) or
           (pontuacao = 0) then
        begin
          pontuacao := VerificaCartasSemelhantes(auxA);
          refCartaEscolhida := auxA;
        end;
      end;
    end;

    if (refCartaEscolhida > 0) then
    begin
      JogaCarta(refCartaEscolhida, jogadorRef);
      Exit;
    end else
    begin
      PegaCarta(1, jogadorRef); //Compra uma carta do monte
      if CartaJogavel(partida.jogador[jogadorRef].mao[partida.jogador[jogadorRef].quantCartas]) then
      begin
        JogaCarta(partida.jogador[jogadorRef].quantCartas, jogadorRef);
        Exit;
      end;
      GerenciaPainelInformacao(8);
      partida.jogadorRodada := RetornaProximoJogador(partida.jogadorRodada);
    end;

  End;

  {------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------
    BLOCO "ROTINAS_INICIALIZACAO"

    Neste bloco encontram-se as rotinas que realizam o
    trabalho de definir os valores basicos para o inicio
    do programa.

   ------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------}


  {--------------------------------------------------------------------
      Inicializa: Inicializa as definições iniciais da rodada
  ---------------------------------------------------------------------}
  Procedure InicializaRodada;
  Var
  auxA, auxB, cor, posicao : integer;
  Begin
    {-----INICIA CARTAS------}
    for auxA := 1 to 108 do
    begin
      partida.monte[auxA].valor := VALOR_NULL;
      partida.monte[auxA].cor := VALOR_NULL;
    end;

    posicao := 0;
    for auxA := 1 to 4 do
    begin
      case auxA of
        1: cor := COR_VERMELHA;
        2: cor := COR_AZUL;
        3: cor := COR_VERDE;
        4: cor := COR_AMARELA;
      end;
      inc(posicao);
      partida.monte[posicao].valor := CARTA_0; partida.monte[posicao].cor := cor;
      for auxB := 1 to 2 do
      begin
        inc(posicao); partida.monte[posicao].valor := CARTA_1; partida.monte[posicao].cor := cor;
        inc(posicao); partida.monte[posicao].valor := CARTA_2; partida.monte[posicao].cor := cor;
        inc(posicao); partida.monte[posicao].valor := CARTA_3; partida.monte[posicao].cor := cor;
        inc(posicao); partida.monte[posicao].valor := CARTA_4; partida.monte[posicao].cor := cor;
        inc(posicao); partida.monte[posicao].valor := CARTA_5; partida.monte[posicao].cor := cor;
        inc(posicao); partida.monte[posicao].valor := CARTA_6; partida.monte[posicao].cor := cor;
        inc(posicao); partida.monte[posicao].valor := CARTA_7; partida.monte[posicao].cor := cor;
        inc(posicao); partida.monte[posicao].valor := CARTA_8; partida.monte[posicao].cor := cor;
        inc(posicao); partida.monte[posicao].valor := CARTA_9; partida.monte[posicao].cor := cor;
        inc(posicao); partida.monte[posicao].valor := CARTA_COMPRA_2; partida.monte[posicao].cor := cor;
        inc(posicao); partida.monte[posicao].valor := CARTA_INVERTE; partida.monte[posicao].cor := cor;
        inc(posicao); partida.monte[posicao].valor := CARTA_PULA; partida.monte[posicao].cor := cor;
      end;
      inc(posicao);
      partida.monte[posicao].valor := CARTA_COMPRA_4; partida.monte[posicao].cor := COR_CORINGA;
      inc(posicao);
      partida.monte[posicao].valor := CARTA_CORINGA; partida.monte[posicao].cor := COR_CORINGA;
    end;
    {-----INICIA CARTAS------FIM}

    {-----DEFINE VARIÁVEIS RELEVANTES--------}

    partida.jogadorRodada := 1;
    partida.sentido := true;
    partida.jogadorVenceuRodada := false;
    partida.acumulado := 0;
    partida.quantCartasMonte := 108;
    partida.cartaAtual.valor := VALOR_NULL;

    layout.posSelecionada := 4;
    layout.refSecaoBaralho := 1;
    layout.posSecao := 2;
    layout.contadorBloqueio := 0;

    DesenhaRetangulo(CARACTERE_PADRAO, 47,10,10,3,3);

    for auxA := 1 to partida.quantJogadores do
    begin
      partida.jogador[auxA].quantCartas := 0;
      partida.jogador[auxA].uno := false;
      for auxB := 1 to 108 do
      begin
        partida.jogador[auxA].mao[auxB].valor := VALOR_NULL;
        partida.jogador[auxA].mao[auxB].cor := VALOR_NULL;
      end;
    end;

    EmbaralhaCartas;
    DistribuiCartas;

    partida.quantCartasDisponiveis := partida.quantCartasMonte;

    repeat
      partida.cartaAtual := partida.monte[1];

      partida.monte[partida.quantCartasMonte + 1] := partida.monte[1];
      for auxA := 1 to partida.quantCartasMonte + 1 do
      partida.monte[auxA] := partida.monte[auxA + 1];

      partida.monte[partida.quantCartasMonte + 1].valor := VALOR_NULL;
      partida.monte[partida.quantCartasMonte + 1].cor := VALOR_NULL;
    until (partida.cartaAtual.valor <> CARTA_COMPRA_4);

    inc(partida.jogador[partida.jogadorRodada].quantCartas);
    partida.jogador[partida.jogadorRodada].mao[partida.jogador[partida.jogadorRodada].quantCartas] := partida.monte[partida.quantCartasMonte];

    ExibeCartaAtual;
    ExibeCartas(layout.refSecaoBaralho);
    GerenciaPainelJogadores;

    JogaCarta(partida.jogador[partida.jogadorRodada].quantCartas, partida.jogadorRodada);
    ExibeCartas(layout.refSecaoBaralho);
    partida.vezHumano := false;

  End;


  {--------------------------------------------------------------------
      InicializaPartida; : Inicializa as definições de uma partida
  ---------------------------------------------------------------------}
  Procedure InicializaPartida;
  Var
  auxA, auxB, quantNomes, posNomeArquivo : integer;
  nomesArq : text;
  nomeExistente : boolean;
  nome, tecla, auxStrA : string;
  Begin
    textbackground(COR_FUNDO); clrscr; //Pinta todo o fundo de azul marinho

    fimUno := false;
    cursorOff;

    if not(ArquivosDisponiveis) then
    begin
      fimUno := true;
      DesenhaPainel(20,4,40,17,':(', true, false);
      textcolor(lightred); textbackground(7);
      gotoxy(30,6); write('ISSO ', #144, ' UM PROBLEMA!');
      gotoxy(23,8); write('O UNO n', #198, 'o p', #147, 'de ser iniciado porque');
      gotoxy(22,9); write('algum arquivo externo essencial est', #160);
      gotoxy(36,10); write('faltando.');

      gotoxy(25,13); write('Verifique se a pasta DADOS est', #160);
      gotoxy(22,14); write('no mesmo diret', #162, 'rio deste execut', #160, 'vel.');

      gotoxy(27,17); write('No Pascalzim ',#130,' necess',#160,'rio');
      gotoxy(30,18); write('gerar o execut',#160,'vel.');

      readkey;
      Exit;
    end;

    auxA := 2;
    tecla := TECLA_DOWN;

    if PaintZim(concat(DIRETORIO_DADOS, '\LOGO'), 11, 6, false) then
    begin end;
    
    DesenhaPainel(44,2,25,21,'UNO', true, false);
    while (true) do
    begin

      if (tecla = TECLA_UP) or
         (tecla = TECLA_DOWN) then
      begin
        for auxB := 1 to 4 do
        begin
          case auxB of
            1: auxStrA := 'Iniciar partida';
            2: auxStrA := 'Sobre o UNO';
            3: auxStrA := concat('Cr', #130,'ditos');
            4: auxStrA := 'Sair';
          end;
          if auxB = auxA then
          DesenhaBotao(47, (3 + (5 * (auxB - 1))), 17, 3, 7, 7, 15, true, auxStrA)
          else
          DesenhaBotao(47, (3 + (5 * (auxB - 1))), 17, 3, 7, 7, 16, false, auxStrA);
        end;

      end;

      tecla := ObtemTeclaPressionada;
      delay(50);

      if tecla = TECLA_UP then
      begin
        if auxA > 1 then
        dec(auxA);
      end else
      if tecla = TECLA_DOWN then
      begin
        if auxA < 4 then
        inc(auxA);
      end else
      if tecla = TECLA_ENTER then
      begin
        case auxA of
          1: break;
          2: begin
               textbackground(COR_FUNDO); clrscr; //Pinta todo o fundo de azul marinho
               DesenhaPainel(4,3,72,20,'Sobre o UNO                                                 Esc=Voltar', true, false);
               textbackground(7); textcolor(16);
               gotoxy(75, 4); write(#24); gotoxy(75, 22); write(#25);
               auxB := 1;
               ExibeTexto(concat(DIRETORIO_DADOS, '\MANUAL'), auxB,5,5,70,17,16,7);
               while(true) do
               begin
                 delay(50);
                 tecla := ObtemTeclaPressionada;
                 if tecla = TECLA_UP then
                 begin
                   if (auxB > 1) then
                   dec(auxB);
                 end else
                 if tecla = TECLA_DOWN then
                 begin
                   inc(auxB);
                 end else
                 if tecla = TECLA_ESC then
                 begin
                   break;
                 end;

                 if (tecla = TECLA_UP) or
                    (tecla = TECLA_DOWN) then
                 begin
                   //str(auxB, auxStrA);
                   ExibeTexto(concat(DIRETORIO_DADOS, '\MANUAL'), auxB,5,5,70,17,16,7);
                 end;

               end;
               textbackground(COR_FUNDO); clrscr; //Pinta todo o fundo de azul marinho
               tecla := TECLA_DOWN;

               if PaintZim(concat(DIRETORIO_DADOS, '\LOGO'), 11, 6, false) then
               begin end;
               DesenhaPainel(44,2,25,21,'UNO', true, false);
             end;
          3: begin
               textbackground(COR_FUNDO); clrscr; //Pinta todo o fundo de azul marinho
               DesenhaPainel(7,7,30,14,concat('Cr', #130, 'ditos'), true, false);
               textbackground(7); textcolor(16);
               gotoxy(14, 9); write('-Desenvolvedor-');
               gotoxy(12, 11); write('Guilherme Resende S', #160);
               gotoxy(12, 12); write('gresendesa@gmail.com');
               gotoxy(20, 14); write('2013');

               gotoxy(16, 17); write('-ASCII Art-');
               gotoxy(9, 19); write('http://www.chris.com/ascii/');

               if PaintZim(concat(DIRETORIO_DADOS, '\CAIXA'), 42, 5, false) then
               begin end;

               readkey;
               textbackground(COR_FUNDO); clrscr; //Pinta todo o fundo de azul marinho
               tecla := TECLA_DOWN;

               if PaintZim(concat(DIRETORIO_DADOS, '\LOGO'), 11, 6, false) then
               begin end;
               DesenhaPainel(44,2,25,21,'UNO', true, false);
             end;
          4: begin
               fimUno := true;
               Exit;
             end;
        end;
      end;

    end;

    textbackground(COR_FUNDO); clrscr; //Pinta todo o fundo de azul marinho

    partida.inicio := false;

    DesenhaPainel(15,7,21,11,'Nova partida', true, false);
    DesenhaCampo(16,9,17,1,16,lightgray,white,false,'Seu nome');
    DesenhaCampo(16,13,16,1,16,lightgray,black,false,'Jogadores');
    gotoxy(16 + 18, 13 + 1); write(#30);
    gotoxy(16 + 18, 13 + 3); write(#31);

    partida.quantJogadores := 5;

    gotoxy(17, 15); write(partida.quantJogadores);

    if PaintZim(concat(DIRETORIO_DADOS, '\PASSARO'), 40, 4, false) then
    begin end;
    repeat
      DesenhaRetangulo(CARACTERE_PADRAO, 17,11,17,1,7); //Apaga trecho
      textcolor(black);
      gotoxy(17, 11);
    until (LeDado(nome, 15) <> TECLA_NULA);

    DesenhaCampo(16,9,17,1,16,lightgray,black,false,'Seu nome');
    DesenhaCampo(16,13,16,1,16,lightgray,white,false,'Jogadores');

    while(true) do
    begin
      tecla := ObtemTeclaPressionada;
      delay(50);
      if tecla = TECLA_UP then
      begin
        if partida.quantJogadores < 10 then
        inc(partida.quantJogadores);
      end else
      if tecla = TECLA_DOWN then
      begin
        if partida.quantJogadores > 2 then
        dec(partida.quantJogadores);
      end else
      if tecla = TECLA_ENTER then
      begin
        break;
      end;
      if tecla <> ID_NULL then
      begin
        DesenhaRetangulo(CARACTERE_PADRAO, 17,15,2,1,7); //Apaga trecho
        textcolor(black); textbackground(7);
        gotoxy(17, 15); write(partida.quantJogadores);
      end;
    end;

    partida.pontosVitoria := partida.quantJogadores * 50;

    randomize;
    partida.refJogadorHumano := random(partida.quantJogadores) + 1;
    partida.jogador[partida.refJogadorHumano].nome := nome;

    textbackground(COR_FUNDO); clrscr; //Pinta todo o fundo de azul marinho

    DesenhaPainel(31,8,20,7,'Aviso', true, false);
    textcolor(16); textbackground(7);
    gotoxy(33,10); writeln('Pontua',#135,#198,'o m',#160,'xima');
    gotoxy(39,12); writeln(partida.pontosVitoria);
    delay(2000);

    textbackground(COR_FUNDO); clrscr; //Pinta todo o fundo de azul marinho

    assign(nomesArq, concat(DIRETORIO_DADOS, '\NOMES'));
    {$I-} reset(nomesArq); {$I+}
    quantNomes := 0;
    repeat
      readln(nomesArq, nome);
      inc(quantNomes);
    until (eof(nomesArq));
    close(nomesArq);

    for auxA := 1 to partida.quantJogadores do
    begin
      if auxA <> partida.refJogadorHumano then
      begin

        repeat
          posNomeArquivo := random(quantNomes) + 1;
          nomeExistente := false;

          {$I-} reset(nomesArq); {$I+}
          for auxB := 1 to posNomeArquivo do
          begin
            {$I-} readln(nomesArq, nome); {$I+}
          end;
          {$I-} close(nomesArq); {$I+}

          for auxB := 1 to partida.quantJogadores do
          begin
            if partida.jogador[auxB].nome = nome then
            begin
              nomeExistente := true;
              break;
            end;
          end;

        until not(nomeExistente);
        partida.jogador[auxA].nome := nome;
      end;
    end;

    if PaintZim(concat(DIRETORIO_DADOS, '\FACE_MONTE'), 3, 2, false) then
    begin end;

    for auxA := 1 to 10 do
    begin
      partida.jogador[auxA].pontuacao := 0;
    end;

  End;

  {------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------
     BLOCO "ROTINAS_CONTROLES"

     Controla basicamente as entradas feitas através do
     teclado, direcionando cada comando às rotinas
     responsáveis.
   ------- ------- ------- ------- ------- ------- -------
   ------- ------- ------- ------- ------- ------- -------}

  Procedure GerenciaControles (var tecla : string);
  Begin

    if tecla = TECLA_UP then
    begin
      if layout.posSecao > 1 then
      dec(layout.posSecao);
      SelecionaCarta;
    end else
    
    if tecla = TECLA_DOWN then
    begin
      if layout.posSecao < 2 then
      inc(layout.posSecao);
      SelecionaCarta;
    end else
    
    if tecla = TECLA_LEFT then
    begin
      if layout.posSecao > 1 then
      if layout.posSelecionada > 1 then
      begin
        dec(layout.posSelecionada);
        SelecionaCarta;
      end else
      begin
        if layout.refSecaoBaralho > 7 then
        begin
          layout.refSecaoBaralho := layout.refSecaoBaralho - 7;
          ExibeCartas(layout.refSecaoBaralho);
          layout.posSelecionada := 7;
          SelecionaCarta;
        end;
      end;
    end else

    if tecla = TECLA_RIGHT then
    begin
      if layout.posSecao > 1 then
      if layout.posSelecionada < 7 then
      begin
        inc(layout.posSelecionada);
        SelecionaCarta;
      end else
      begin
        if partida.jogador[partida.refJogadorHumano].quantCartas >
          (layout.refSecaoBaralho + layout.posSelecionada - 1) then
        begin
          layout.refSecaoBaralho := layout.refSecaoBaralho + 7;
          ExibeCartas(layout.refSecaoBaralho);
          layout.posSelecionada := 1;
          SelecionaCarta;
        end;
      end;
    end else

    if tecla = TECLA_ESC then
    begin
       textcolor(yellow); textbackground(4); gotoxy(3, 25) ;
       write('Tecle ENTER para sair ou ESC para continuar');
	   tecla := readkey;
	   gotoxy(3, 25) ;
       textbackground(3);
       write('                                                              '); gotoxy(80,1);
       if tecla = #13 then
       begin
         partida.inicio := true;
         Exit;
       End;
       SelecionaCarta;
    end else

    if tecla = TECLA_ENTER then
    begin
      if partida.refJogadorHumano = partida.jogadorRodada then
      if layout.posSecao > 1 then
      begin
        if (partida.acumulado = 0) or
           ((partida.acumulado > 0) and
            (partida.jogador[partida.refJogadorHumano].mao[layout.refSecaoBaralho + layout.posSelecionada - 1].valor = CARTA_COMPRA_2)) then
        begin
          if ((partida.jogador[partida.refJogadorHumano].mao[layout.refSecaoBaralho + layout.posSelecionada - 1].valor =
               partida.cartaAtual.valor) or
              (partida.jogador[partida.refJogadorHumano].mao[layout.refSecaoBaralho + layout.posSelecionada - 1].cor =
               partida.cartaAtual.cor) or
              (partida.jogador[partida.refJogadorHumano].mao[layout.refSecaoBaralho + layout.posSelecionada - 1].valor =
               CARTA_CORINGA) or
              (partida.jogador[partida.refJogadorHumano].mao[layout.refSecaoBaralho + layout.posSelecionada - 1].valor =
               CARTA_COMPRA_4)) then
          begin

            JogaCarta((layout.refSecaoBaralho + layout.posSelecionada - 1), partida.refJogadorHumano);
            if (partida.jogador[partida.refJogadorHumano].quantCartas <
            layout.refSecaoBaralho) and
            (partida.jogador[partida.refJogadorHumano].quantCartas > 1) then
            begin
              layout.posSelecionada := 7;
              layout.refSecaoBaralho := layout.refSecaoBaralho - 7;
              ExibeSetas;
            End;

            inc(partida.jogador[partida.refJogadorHumano].quantCartas);
            ExibeCartas(layout.refSecaoBaralho);
            dec(partida.jogador[partida.refJogadorHumano].quantCartas);

            SelecionaCarta;
            partida.vezHumano := false;
            layout.contadorBloqueio := 0;

          end;
        end;
      end else
      begin
        if partida.acumulado = 0 then
        begin
          PegaCarta(1, partida.refJogadorHumano);
          if CartaJogavel(partida.jogador[partida.refJogadorHumano].mao[partida.jogador[partida.refJogadorHumano].quantCartas]) then
          begin
            delay(1000);
            if partida.jogador[partida.refJogadorHumano].quantCartas = 2 then
            partida.jogador[partida.refJogadorHumano].uno := true;
            JogaCarta(partida.jogador[partida.refJogadorHumano].quantCartas, partida.refJogadorHumano);
            if partida.jogador[partida.refJogadorHumano].quantCartas <
            layout.refSecaoBaralho then
            begin
              layout.posSelecionada := 7;
              layout.refSecaoBaralho := layout.refSecaoBaralho - 7;
              ExibeCartas(layout.refSecaoBaralho);
              SelecionaCarta;
              ExibeSetas;
            End;
            inc(partida.jogador[partida.refJogadorHumano].quantCartas);
            ExibeCartas(layout.refSecaoBaralho);
            dec(partida.jogador[partida.refJogadorHumano].quantCartas);
            partida.vezHumano := false;
            layout.contadorBloqueio := 0;
          end else
          begin
            GerenciaPainelInformacao(8);
            partida.jogadorRodada := RetornaProximoJogador(partida.refJogadorHumano);
            partida.vezHumano := not(partida.vezHumano);
            layout.contadorBloqueio := 0;
          end;
        end;
      end;
    end else

    if (tecla = '85') or  {tecla 'U' ou 'u'}
       (tecla = '117') then
    begin
      if partida.jogador[partida.refJogadorHumano].quantCartas = 2 then
      begin
        DesenhaBotao(47,10,6,1,3,3,15,true,'Uno[U]');
        delay(300);
        DesenhaBotao(47,10,6,1,3,3,15,false,'Uno[U]');
        partida.jogador[partida.refJogadorHumano].uno := true;
      end;
    end;

  End;

 {--------------------------------------------------------------------
     PROGRAMA PRINCIPAL
  ---------------------------------------------------------------------}
Begin

  //SetConsoleTitle('UNO');

  partida.inicio := true;

  while(true) do
  begin
    if partida.inicio then
    begin
      InicializaPartida;
      if fimUno then
      Exit; //Sai do jogo
      InicializaRodada;
      textcolor(white);
    end;

    inc(layout.contadorBloqueio);
    delay(50);

    if not(partida.vezHumano) then
    begin
      if partida.jogadorRodada = partida.refJogadorHumano then
      begin
        partida.vezHumano := true;
        GerenciaPainelInformacao(2);
      end else
      begin
        partida.vezHumano := false;
        if layout.contadorBloqueio = 26 then
        JogaIA(partida.jogadorRodada);
      end;
      //gotoxy(1, 26); Debug_ExibeCartasJogadores; writeln; Debug_ExibeCartas; writeln;
      //writeln(partida.quantCartasDisponiveis,'  ');
    end;

    if layout.contadorBloqueio = 13 then
    GerenciaPainelJogadores;

    layout.leituraTeclado := ObtemTeclaPressionada;

    if layout.leituraTeclado <> TECLA_NULA then
    begin
      GerenciaControles(layout.leituraTeclado);
      ExibeSetas;
      //gotoxy(1, 26); Debug_ExibeCartasJogadores; writeln; Debug_ExibeCartas; writeln;
      //writeln(partida.quantCartasDisponiveis,'  ');
    end;

    if partida.jogadorVenceuRodada then
    begin
      ComputaPontuacao;
      if (partida.jogador[partida.jogadorRodada].pontuacao < partida.pontosVitoria) then
      begin
        GerenciaPainelInformacao(10);
        readkey;
        InicializaRodada;
      end else
      begin
        GerenciaPainelInformacao(11);
        while(true) do
        begin
          if keypressed then
          if upcase(readkey) = 'C' then
          break;
          delay(50);
        end;
        partida.inicio := true;
      end;
    end;

  end;

End.
