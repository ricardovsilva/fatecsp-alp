Unit UnitPaintZim;
{Programa sem proprietário.
 Descrição: Esta unidade possui a funcionalidade de carregar desenhos
 elaborados no PaintZim20 e exibi-los na tela.

 Modelo de chamada da função:

 PaintZim(caminho_do_arquivo,
          posicao_coluna_tela,
          posicao_linha_tela,
          presenca_do_fundo);

 Exemplo: PaintZim('.\desenho', 5, 1, true);
 Neste exemplo o arquivo "desenho.paintzim" que está na mesma
 pasta do programa vai ser desenhado na tela à partir da coluna 5,
 linha 1, com a presença do fundo do desenho.

 ESTA UNIDADE PODE SER REUTILIZADA SEM RESTRIÇÕES :-)
 }

Interface
  Uses crt;
  Function PaintZim(caminhoArquivo : string;
                    posCol, posLin : integer;
                    presencaFundo : boolean) : boolean;
Implementation

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
     Function CarregaPaintzim;
  -----------------------------------------------------}
  Function PaintZim(caminhoArquivo : string;
                    posCol, posLin : integer;
                    presencaFundo : boolean) : boolean;
  Var
  strPosC, strPosL,
  strCaractere, strCorCaractere, strCorFundoCaractere, registro, linha : string;
  refColInicio, refColFim, refLinInicio, refLinFim, corFundo, cont : integer;
  arq : text;
  Begin
    assign(arq, concat(caminhoArquivo,'.paintzim'));
    {$I-} reset(arq); {$I+}
    if IOResult = 0 then
    begin
      readln(arq, registro);
      if (registro <> 'Arquivo PaintZim20') then {Verifica versão}
      begin
        PaintZim := false;
        close(arq);
        Exit;
      end;

      readln(arq, registro);
      corFundo := StringParaInt(copy(registro, 1, 3)); {Captura cor de fundo}

      readln(arq, registro); {Captura limites do desenho}
      refColInicio := StringParaInt(copy(registro, 1, 3));
      refColFim := StringParaInt(copy(registro, 4, 3));
      refLinInicio := StringParaInt(copy(registro, 7, 3));
      refLinFim := StringParaInt(copy(registro, 10, 3));
      close(arq);

      if presencaFundo then {Desenha fundo}
      begin
        textcolor(corFundo); textbackground(corFundo) ;
        linha := '';
        for cont := 1 to refColFim - refColInicio + 1 do
        if (cont > 1) then
        linha := concat(linha, #219)
        else
        linha := #219;
        for cont := 1 to refLinFim - refLinInicio + 1 do
        begin
          gotoxy(posCol, posLin + cont - 1) ;
          write(linha);
        end;
      end;

      reset(arq);
      readln(arq); readln(arq); readln(arq);

      repeat
        readln(arq, registro);
        strPosC := copy(registro, 1, 3);
        strPosL := copy(registro, 4, 3);
        strCaractere := copy(registro, 7, 3);
        strCorCaractere := copy(registro, 10, 3);
        strCorFundoCaractere := copy(registro, 13, 3);
        gotoxy(posCol + StringParaInt(strPosC) - refColInicio , posLin + StringParaInt(strPosL) - refLinInicio);
        textcolor(StringParaInt(strCorCaractere)); textbackground(StringParaInt(strCorFundoCaractere));
        writeln(chr(StringParaInt(strCaractere)));
      until(eof(arq));

      close(arq);

      PaintZim := true;
    end else
    begin
      textcolor(yellow); textbackground(red);
      gotoxy(posCol, posLin); writeln('!ERRO:FICHEIRO_AUSENTE!');
      PaintZim := false;
    end;
  End;

End.
