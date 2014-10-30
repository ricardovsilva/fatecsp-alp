unit SellsScreen;
interface
  Procedure ShowSellsScreen(sellsFile : string; productsFile : string);
  procedure ShowSelectedMenu(sellsFile : string; productsFile : string; option : integer);
  procedure ShowRandomSells(sellsFile: string; productsFile: string);
implementation

  uses
    SellsUtils,
    InputUtils;

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
      Writeln('[1] Gerar vendas aleat�rias');
      Writeln('[2] Consultar vendas feitas');
      Writeln('[3] Voltar ao menu principal');
      Write('Digite a op��o desejada: ');
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
      Writeln('Fun��o n�o implementada ainda. Aguarde nova vers�o');
      Writeln('Pressione qualquer tecla para continuar...');
      Readkey;
    end;
  end;
  
  procedure ShowRandomSells(sellsFile: string; productsFile: string);
  var
    year, month, quantity, percentage : integer;
  const
    sellMax = 50;
    sellMin = 25;
  begin
    Clrscr;
    Writeln('--------V E N D A S--------');
    Write('Digite o ano ao qual as vendas ser�o geradas: ');
    Readln(year);
    
    Write('Digite o m�s ao qual as vendas ser�o geradas: ');
    Readln(month);
    
    quantity := GetsInteger('Digite a quantidade de vendas aleat�rias a serem geradas por dia: ', sellMin, sellMax);
    
    Write('Digite a porcentagem de varia��o dos pre�os (em inteiro): ');
    Readln(percentage);
    
    GenerateRandomSells(sellsFile, productsFile, year, month, quantity, percentage);
    
    Writeln(quantity, ' vendas geradas com sucesso!');
    Writeln('Pressione qualquer tecla para voltar ao menu anterior...');
    Readkey;
  end;
end.