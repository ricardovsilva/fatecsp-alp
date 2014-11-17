Program TestGenerator ;
  uses
    ProductHandler,
    StringUtils,
    RealUtils,
    RandomUtils,
    DateTimeUtils,
    ProductUtils,
    SellsUtils,
    MainMenu,
    crt,
    sysutils;
const
  filePath = 'Produtos.txt';
  sellsPath = 'Vendas.txt';
  statisticsPath = 'TotVendas.txt';
var
  tempSell : Sell;
  tempProduct : Product;
  i : integer;
Begin

  ShowMainMenu(filePath, sellsPath, statisticsPath);
  Clrscr;
  Writeln('Obrigado por utilizar o gerador automatico de testes...');
  Readkey;
end.
