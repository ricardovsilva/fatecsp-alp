unit SellsScreen;
interface
  Procedure ShowSellsScreen(sellsFile : string; productsFile : string);
  procedure ShowSelectedMenu(sellsFile : string; productsFile : string; option : integer);
  procedure ShowRandomSells(sellsFile: string; productsFile: string);
implementation

  uses
    SellsUtils;

  Procedure ShowSellsScreen(sellsFile : string; productsFile : string);
  const
    quit = 3;
  var
    option : integer;
    quantityOfSells : integer;
    year : integer;
    month : integer;  
  begin
    option := 0;
    
    repeat
      clrscr;
      Writeln('--------V E N D A S--------');
      Writeln('[1] Gerar vendas aleatórias');
      Writeln('[2] Consultar vendas feitas');
      Writeln('[3] Voltar ao menu principal');
      Write('Digite a opção desejada: ');
      Readln(option);
      
      ShowSelectedMenu(sellsFile, productsFile, option);
    until option = quit;
  end;
  
  procedure ShowSelectedMenu(sellsFile : string; productsFile : string; option : integer);
  const
    randomSells = 1;
    consultSells = 2;
  begin
    if option = randomSells then
    begin
      ShowRandomSells(sellsFile, productsFile);
    end
    
    else if option = consultSells then
    begin
      Writeln('Função não implementada ainda. Aguarde nova versão');
      Writeln('Pressione qualquer tecla para continuar...');
      Readkey;
    end;
  end;
  
  procedure ShowRandomSells(sellsFile: string; productsFile: string);
  var
    year, month, quantity, percentage : integer;
  begin
    Clrscr;
    Writeln('--------V E N D A S--------');
    Write('Digite o ano ao qual as vendas serão geradas: ');
    Readln(year);
    
    Write('Digite o mês ao qual as vendas serão geradas: ');
    Readln(month);
    
    Write('Digite a quantidade de vendas aleatórias a serem geradas (máx 20k): ');
    Readln(quantity);
    
    Write('Digite a porcentagem de variação dos preços (em inteiro): ');
    Readln(percentage);
    
    //GenerateRandomSells(sellsFile, productsFile, year, month, quantity, percentage);
    
    Writeln(quantity, ' vendas geradas com sucesso!');
    Writeln('Pressione qualquer tecla para voltar ao menu anterior...');
    Readkey;
  end;
end.